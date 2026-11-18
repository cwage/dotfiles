# Home Manager module that symlinks dotfiles.
# Per-host X11 variants (.Xresources.<host> / .xsession.<host>) are picked
# from osConfig.networking.hostName.
#
# dotfiles.profile selects what gets linked on top of the shared desktop:
#   personal — personal identity (git, mail) and personal session autostarts
#              (.xsession.personal).
#   work     — shared desktop only. ~/.gitconfig.local is left unmanaged so
#              employer onboarding tooling can write to it.
#
# dotfiles.ssh.personalHosts (default: on for personal, off for work) makes the
# personal ssh hosts available without taking ownership of ~/.ssh/config, so
# tools like `step ssh config` can keep editing that file. See below.
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

  options.dotfiles.ssh.personalHosts = lib.mkOption {
    type = lib.types.bool;
    default = personal;
    defaultText = lib.literalExpression ''config.dotfiles.profile == "personal"'';
    description = ''
      Link the personal ssh hosts to ~/.ssh/config.d/personal and make sure
      ~/.ssh/config includes config.d/*. ~/.ssh/config itself stays a normal
      mutable file (not a store symlink), so other tooling can own it.
    '';
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

      # mpd (file only — mpd needs the directory writable for database/playlists)
      home.file.".config/mpd/mpd.conf".source = "${dotfilesPath}/.config/mpd/mpd.conf";
    })

    (lib.mkIf config.dotfiles.ssh.personalHosts {
      # Only the one file is linked, not ~/.ssh/config.d as a whole, so other
      # tooling can drop its own fragments alongside it (keys stay local too).
      home.file.".ssh/config.d/personal".source = "${dotfilesPath}/.ssh/config.d/personal";

      # ~/.ssh/config is deliberately NOT a home.file: `step ssh config` and
      # similar onboarding tools create and rewrite it, and a read-only store
      # symlink would break them (or get clobbered by them). Instead, append
      # the Include once if it's missing and leave the rest of the file alone.
      #
      # `Match all` resets the context first: Include is conditional on the
      # enclosing Host/Match block, and the existing file may well end inside
      # one (e.g. a `Match exec ...` block). Appending at the end also means
      # anything already in the file wins on conflicts, since ssh takes the
      # first value it sees for each option.
      #
      # Runs after linkGeneration so a stale ~/.ssh/config symlink left by the
      # old personal profile (which managed this file) has been cleaned up.
      home.activation.sshConfigInclude = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        sshConfig="$HOME/.ssh/config"
        includeLine='Include config.d/*'
        if [ -L "$sshConfig" ]; then
          warnEcho "$sshConfig is a symlink; not touching it." \
                   "Add '$includeLine' to it by hand for the personal ssh hosts."
        elif ! ${pkgs.gnugrep}/bin/grep -qxF "$includeLine" "$sshConfig" 2>/dev/null; then
          if [[ -v DRY_RUN ]]; then
            echo "Would append '$includeLine' to $sshConfig"
          else
            verboseEcho "Appending '$includeLine' to $sshConfig"
            ${pkgs.coreutils}/bin/install -d -m 700 "$HOME/.ssh"
            [ -e "$sshConfig" ] || ${pkgs.coreutils}/bin/install -m 600 /dev/null "$sshConfig"
            printf '\n# Personal ssh hosts (added by the dotfiles home-manager module)\nMatch all\n%s\n' \
              "$includeLine" >> "$sshConfig"
          fi
        fi
      '';
    })
  ];
}
