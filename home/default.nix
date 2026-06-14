# Home Manager module that symlinks dotfiles.
# Per-host X11 variants (.Xresources.<host> / .xsession.<host>) are picked
# from osConfig.networking.hostName.
{ config, lib, pkgs, osConfig, ... }:

let
  dotfilesPath = ./..;
  hostName = osConfig.networking.hostName;
in
{
  # Shell
  home.file.".bashrc".source = "${dotfilesPath}/.bashrc";
  home.file.".bash_profile".source = "${dotfilesPath}/.bash_profile";

  # Git
  home.file.".gitconfig".source = "${dotfilesPath}/.gitconfig";
  home.file.".gitignore".source = "${dotfilesPath}/.gitignore";

  # Tmux
  home.file.".tmux.conf".source = "${dotfilesPath}/.tmux.conf";

  # Emacs/Spacemacs
  home.file.".spacemacs".source = "${dotfilesPath}/.spacemacs";
  home.activation.spacemacs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.emacs.d/.git" ]; then
      run ${pkgs.git}/bin/git clone --branch develop https://github.com/syl20bnr/spacemacs.git "$HOME/.emacs.d"
    fi
  '';

  # X11 — per-host variants selected by hostname
  home.file.".Xresources".source = "${dotfilesPath}/.Xresources.${hostName}";
  home.file.".xsession" = {
    source = "${dotfilesPath}/.xsession.${hostName}";
    executable = true;
  };
  home.file.".xkb".source = "${dotfilesPath}/.xkb";

  # Terminal/colors
  home.file.".dir_colors".source = "${dotfilesPath}/.dir_colors";

  # XDG config dirs
  home.file.".config/awesome".source = "${dotfilesPath}/.config/awesome";
  home.file.".config/btop".source = "${dotfilesPath}/.config/btop";
  home.file.".config/udiskie".source = "${dotfilesPath}/.config/udiskie";
  home.file.".config/xfce4".source = "${dotfilesPath}/.config/xfce4";

  # GPG
  home.file.".gnupg/gpg-agent.conf".source = "${dotfilesPath}/.gnupg/gpg-agent.conf";

  # Mutt - note the different hierarchy mapping
  home.file.".muttrc".source = "${dotfilesPath}/mutt/muttrc";
  home.file.".config/mutt/mailcap".source = "${dotfilesPath}/mutt/mailcap";

  # SSH - only config.d, not the whole directory (keys stay local)
  home.file.".ssh/config.d".source = "${dotfilesPath}/.ssh/config.d";

  # Fonts
  home.file.".fonts".source = "${dotfilesPath}/.fonts";

  # mpd (file only — mpd needs the directory writable for database/playlists)
  home.file.".config/mpd/mpd.conf".source = "${dotfilesPath}/.config/mpd/mpd.conf";
}
