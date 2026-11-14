# Home Manager module that symlinks dotfiles.
# Per-host X11 variants (.Xresources.<host> / .xsession.<host>) are picked
# from osConfig.networking.hostName.
#
# dotfiles.profile selects what gets linked on top of the shared desktop:
#   personal — personal identity (git, mail), personal ssh hosts, and personal
#              session autostarts (.xsession.personal).
#   work     — shared desktop only. ~/.ssh and ~/.gitconfig.local are left
#              unmanaged so employer onboarding tooling can write to them.
{ config, lib, pkgs, osConfig, ... }:

let
  dotfilesPath = ./..;
  hostName = osConfig.networking.hostName;
  personal = config.dotfiles.profile == "personal";
in
{
  options.dotfiles.profile = lib.mkOption {
    type = lib.types.enum [ "personal" "work" ];
    default = "personal";
    description = "Which set of dotfiles to link on top of the shared desktop config.";
  };

  config = lib.mkMerge [
    {
      # Shell
      home.file.".bashrc".source = "${dotfilesPath}/.bashrc";
      home.file.".bash_profile".source = "${dotfilesPath}/.bash_profile";

      # Git — identity lives in ~/.gitconfig.local (included from .gitconfig)
      home.file.".gitconfig".source = "${dotfilesPath}/.gitconfig";
      home.file.".gitignore".source = "${dotfilesPath}/.gitignore";

      # Tmux
      home.file.".tmux.conf".source = "${dotfilesPath}/.tmux.conf";

      # Emacs/Spacemacs
      home.file.".spacemacs".source = "${dotfilesPath}/.spacemacs";
      # Bootstrap spacemacs on a fresh account — best-effort by design.
      #
      # home-manager-<user>.service is WantedBy=multi-user.target and ordered
      # only After=nix-daemon.socket, so at boot it runs long before the
      # network is up; the activation script runs under `set -eu -o pipefail`,
      # so a failed clone fails the *entire* activation and leaves the system
      # "degraded". That is exactly what happened on darterpro's first boot:
      # "fatal: unable to access ... Could not resolve host: github.com" —
      # after all the file links had already been made. So never let this step
      # return non-zero.
      #
      # The guard also has to tolerate a non-empty ~/.emacs.d that isn't a
      # checkout: emacs creates ~/.emacs.d/eln-cache on first run, and
      # `git clone` into a non-empty directory fails, which would otherwise
      # wedge this step permanently once a vanilla emacs has started.
      home.activation.spacemacs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        spacemacsRepo=https://github.com/syl20bnr/spacemacs.git
        if [ ! -e "$HOME/.emacs.d/.git" ]; then
          if [ -n "$(${pkgs.coreutils}/bin/ls -A "$HOME/.emacs.d" 2>/dev/null)" ]; then
            warnEcho "~/.emacs.d exists but is not a git checkout; leaving it alone." \
                     "To bootstrap spacemacs: move it aside, then" \
                     "git clone --branch develop $spacemacsRepo ~/.emacs.d"
          else
            run ${pkgs.git}/bin/git clone --branch develop "$spacemacsRepo" "$HOME/.emacs.d" \
              || warnEcho "spacemacs clone failed (no network yet this early in boot?);" \
                          "retry with: git clone --branch develop $spacemacsRepo ~/.emacs.d"
          fi
        fi
      '';

      # X11 — per-host variants selected by hostname
      home.file.".Xresources".source = "${dotfilesPath}/.Xresources.${hostName}";
      home.file.".xsession" = {
        source = "${dotfilesPath}/.xsession.${hostName}";
        executable = true;
      };
      home.file.".xkb".source = "${dotfilesPath}/.xkb";

      # Pointer cursor theme (macbookpro only for now). With no theme installed
      # where libXcursor looks, X falls back to its built-in bitmap cursors, which
      # are a fixed ~16px and ignore Xcursor.size — unusable on the Retina panel.
      # This links Adwaita into ~/.icons and makes it the default theme. The X11
      # backend (x11.enable) is left off because it would generate ~/.Xresources,
      # which is managed above; Xcursor.theme/size live in .Xresources.<host>.
      home.pointerCursor = lib.mkIf (hostName == "macbookpro") {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 48;
      };

      # Screen lock wrapper used by .xsession (xss-lock/xautolock) and awesome
      home.file.".local/bin/xscreensaver-lock" = {
        source = "${dotfilesPath}/bin/xscreensaver-lock";
        executable = true;
      };

      # Terminal/colors
      home.file.".dir_colors".source = "${dotfilesPath}/.dir_colors";

      # XDG config dirs
      home.file.".config/awesome".source = "${dotfilesPath}/.config/awesome";
      home.file.".config/btop".source = "${dotfilesPath}/.config/btop";
      home.file.".config/udiskie".source = "${dotfilesPath}/.config/udiskie";
      home.file.".config/xfce4".source = "${dotfilesPath}/.config/xfce4";

      # GPG
      home.file.".gnupg/gpg-agent.conf".source = "${dotfilesPath}/.gnupg/gpg-agent.conf";

      # Fonts
      home.file.".fonts".source = "${dotfilesPath}/.fonts";
    }

    (lib.mkIf personal {
      # Git identity
      home.file.".gitconfig.local".source = "${dotfilesPath}/.gitconfig.personal";

      # Personal session autostarts, sourced by .xsession
      home.file.".xsession.personal".source = "${dotfilesPath}/.xsession.personal";

      # Mutt - note the different hierarchy mapping
      home.file.".muttrc".source = "${dotfilesPath}/mutt/muttrc";
      home.file.".config/mutt/mailcap".source = "${dotfilesPath}/mutt/mailcap";

      # SSH - only config + config.d, not the whole directory (keys stay local)
      home.file.".ssh/config".text = "Include config.d/*\n";
      home.file.".ssh/config.d".source = "${dotfilesPath}/.ssh/config.d";

      # mpd (file only — mpd needs the directory writable for database/playlists)
      home.file.".config/mpd/mpd.conf".source = "${dotfilesPath}/.config/mpd/mpd.conf";
    })
  ];
}
