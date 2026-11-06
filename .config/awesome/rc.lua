-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "xterm"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1"

-- Machine-specific settings based on hostname
local handle = io.popen("hostname")
local hostname = handle:read("*l")
handle:close()
local wibar_height = 20
local font_size = 6

if hostname == "portaptty" then
    wibar_height = 30
    font_size = 9
elseif hostname == "macbookpro" then
    -- 16" Retina at 3072x1920 (~226 DPI). 2x of thinkpad's 6/20.
    wibar_height = 40
    font_size = 12
end

-- Set font early so widgets use the correct size
beautiful.font = "DejaVu Sans " .. font_size

-- {{{ Tag contexts
-- A context is a full set of tags 1-9. Mod+N, the tag list and next/prev all
-- act on the current context only, and a key flips between contexts, so
-- "Mod+2" can be the personal browser in one and the work browser in the
-- other. Hosts with a single context behave exactly as before.
local contexts = { "main" }
if hostname == "macbookpro" then
    contexts = { "personal", "work" }
end
local tags_per_context = 9
local current_context = 1
local context_widget = wibox.widget.textbox()

local function update_context_widget()
    if #contexts > 1 then
        context_widget.markup = " <b>" .. contexts[current_context] .. "</b> "
    end
end
update_context_widget()

-- Tag i (1-9) of the current context on screen s.
local function context_tag(s, i)
    return s.tags[(current_context - 1) * tags_per_context + i]
end

-- Position (1-9) of tag t within its own context.
local function context_index(t)
    return (t.index - 1) % tags_per_context + 1
end

local function tag_in_current_context(t)
    return math.floor((t.index - 1) / tags_per_context) + 1 == current_context
end

-- Flip to the next context, returning each screen to the tag it was last on
-- in that context.
local function next_context()
    for s in screen do
        s.context_last = s.context_last or {}
        if s.selected_tag then
            s.context_last[current_context] = context_index(s.selected_tag)
        end
    end
    current_context = current_context % #contexts + 1
    for s in screen do
        local t = context_tag(s, (s.context_last or {})[current_context] or 1)
        if t then t:view_only() end
    end
    update_context_widget()
end

-- Next/previous tag, wrapping within the current context.
local function view_context_relative(offset)
    local s = awful.screen.focused()
    local cur = s.selected_tag and context_index(s.selected_tag) or 1
    local t = context_tag(s, (cur - 1 + offset) % tags_per_context + 1)
    if t then t:view_only() end
end

-- Send the focused window to the next context, onto the tag that context was
-- last showing. The view stays where it is.
local function move_client_to_next_context()
    local c = client.focus
    if not c or #contexts < 2 then return end
    local s = c.screen
    local target = current_context % #contexts + 1
    local i = (s.context_last or {})[target] or 1
    local t = s.tags[(target - 1) * tags_per_context + i]
    if t then c:move_to_tag(t) end
end
-- }}}

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
     awful.layout.suit.max,
     awful.layout.suit.floating,
--     awful.layout.suit.tile,
--     awful.layout.suit.tile.left,
--     awful.layout.suit.tile.bottom,
--     awful.layout.suit.tile.top,
--     awful.layout.suit.fair,
     awful.layout.suit.fair.horizontal,
--     awful.layout.suit.spiral,
--     awful.layout.suit.spiral.dwindle,
--     awful.layout.suit.max.fullscreen,
--     awful.layout.suit.magnifier,
--     awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

mymainmenu = awful.menu({
    items = {
              menu_awesome,
              menu_terminal,
            },
    theme = {
        bg_normal = "#eee8d5",
        bg_focus  = "#93a1a1",
        fg_normal = "#222222",
        fg_focus  = "#222222",
    }
})


mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a battery widget (reads directly from sysfs, survives suspend)
local battery_widget = awful.widget.watch(
    [[sh -c 'status=$(cat /sys/class/power_supply/BAT0/status); cap=$(cat /sys/class/power_supply/BAT0/capacity); ac=$(cat /sys/class/power_supply/AC/online); [ "$status" = "Not charging" ] && [ "$ac" = "1" ] && status=Holding; printf "%s %s%%" "$status" "$cap"']],
    30
)

-- Create a textclock widget
mytextclock = awful.widget.textclock("%a %b %d, %I:%M", 60)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function() view_context_relative(1) end),
                    awful.button({ }, 5, function() view_context_relative(-1) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    -- One set of tags 1-9 per context (see "Tag contexts" above).
    for c = 1, #contexts do
        for i = 1, tags_per_context do
            awful.tag.add(tostring(i), {
                screen   = s,
                layout   = awful.layout.layouts[1],
                selected = (c == current_context and i == 1),
            })
        end
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = tag_in_current_context,
        buttons = taglist_buttons,
        style   = {
            bg_focus = "#93a1a1",
            fg_focus = "#222222",
        }
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style   = {
            bg_normal = "#eee8d5",
            fg_normal = "#222222",
            bg_focus  = "#eee8d5",
            fg_focus  = "#222222",
        }
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height = wibar_height, bg = "#eee8d5", fg = "#222222" })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            context_widget,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            battery_widget,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, function() view_context_relative(1) end),
    awful.button({ }, 5, function() view_context_relative(-1) end)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   function () view_context_relative(-1) end,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  function () view_context_relative(1) end,
              {description = "view next", group = "tag"}),
    -- With several contexts this key flips between them; otherwise it keeps
    -- the stock "previous tag" behaviour. (With the Esc/grave hwdb swap,
    -- Escape is the physical key above Tab.)
    awful.key({ modkey,           }, "Escape",
              #contexts > 1 and next_context or awful.tag.history.restore,
              {description = "switch context / go back", group = "tag"}),
    awful.key({ modkey, "Shift"   }, "Escape", move_client_to_next_context,
              {description = "send window to the other context", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
    function ()
        -- awful.client.focus.history.previous()
        awful.client.focus.byidx(-1)
        if client.focus then
            client.focus:raise()
        end
    end),

awful.key({ modkey, "Shift"   }, "Tab",
    function ()
        -- awful.client.focus.history.previous()
        awful.client.focus.byidx(1)
        if client.focus then
            client.focus:raise()
        end
    end),


    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),

    awful.key({ modkey, "Control" }, "Return", function () awful.util.spawn(os.getenv("HOME") .. "/bin/startterms.sh") end),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.spawn(os.getenv("HOME") .. "/.local/bin/xscreensaver-lock") end,
              {description = "lock screen", group = "system"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Shift" }, "r",
      function ()
        awful.spawn.with_shell("~/bin/somafm.sh -r")
      end,
      {description = "play random SomaFM stream", group = "media"}
    ),
    awful.key({ modkey, "Shift" }, "d",
      function ()
        awful.spawn.with_shell("~/bin/somafm.sh defcon")
      end,
      {description = "toggle SomaFM DEF CON stream", group = "media"}
    ),
    awful.key({ modkey, "Shift" }, "s",
      function ()
        awful.spawn.with_shell("~/bin/somafm.sh secretagent")
      end,
      {description = "toggle SomaFM DEF CON stream", group = "media"}
    ),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    -- Custom
    awful.key({ modkey }, "\\", function () awful.util.spawn_with_shell("xmms2 toggle") end),
    awful.key({ modkey }, "'", function () awful.util.spawn_with_shell("randomalbum.sh") end),
    awful.key({ modkey }, ";", function () awful.util.spawn_with_shell("nowplaying.sh") end),
    awful.key({ modkey }, "[", function () awful.util.spawn_with_shell("xmms2 prev") end),
    awful.key({ modkey }, "]", function () awful.util.spawn_with_shell("xmms2 next") end)


)

-- Touch Bar / media keys (macbookpro only). The Touch Bar sends ordinary
-- XF86 key events; with no desktop environment nothing acts on them, so bind
-- them here. gmux_backlight is named explicitly because the Touch Bar's own
-- backlight is also a backlight device and brightnessctl may pick it instead.
if hostname == "macbookpro" then
    local function sh(cmd)
        return function() awful.spawn.with_shell(cmd) end
    end
    globalkeys = gears.table.join(globalkeys,
        awful.key({}, "XF86MonBrightnessUp",   sh("brightnessctl -q -d gmux_backlight set 5%+"),
                  {description = "screen brightness up", group = "media"}),
        awful.key({}, "XF86MonBrightnessDown", sh("brightnessctl -q -d gmux_backlight set 5%-"),
                  {description = "screen brightness down", group = "media"}),
        awful.key({}, "XF86KbdBrightnessUp",   sh("brightnessctl -q -d :white:kbd_backlight set 10%+"),
                  {description = "keyboard backlight up", group = "media"}),
        awful.key({}, "XF86KbdBrightnessDown", sh("brightnessctl -q -d :white:kbd_backlight set 10%-"),
                  {description = "keyboard backlight down", group = "media"}),
        awful.key({}, "XF86AudioRaiseVolume",  sh("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"),
                  {description = "volume up", group = "media"}),
        awful.key({}, "XF86AudioLowerVolume",  sh("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
                  {description = "volume down", group = "media"}),
        awful.key({}, "XF86AudioMute",         sh("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
                  {description = "mute", group = "media"})
    )
end

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = context_tag(screen, i)
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = context_tag(screen, i)
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = context_tag(client.focus.screen, i)
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = context_tag(client.focus.screen, i)
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- OBS: drop modkey (Alt) mouse bindings so Alt+drag reaches OBS (crop in preview).
    { rule = { class = "obs" },
      properties = { buttons = gears.table.join(
          awful.button({ }, 1, function (c)
              c:emit_signal("request::activate", "mouse_click", {raise = true})
          end))
      }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Fix xterm maximization
    { rule = { class = "XTerm" },
      properties = { size_hints_honor = false }},

    -- Fix gqrx requesting a window larger than the screen
    { rule = { class = "gqrx" },
      properties = { size_hints_honor = false }},

--      { rule = { class = "Darktable" },
--        properties = { titlebars_enabled = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

beautiful.bg_systray = "#eee8d5"
