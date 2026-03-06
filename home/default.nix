# Home Manager module that symlinks dotfiles
# NOTE: Currently hardcoded for thinkpad. For multi-host support,
# refactor to use Home Manager options.
{ config, lib, pkgs, ... }:

let
  dotfilesPath = ./..;
in
{
  # Shell
  home.file.".bashrc".source = "${dotfilesPath}/.bashrc";
  home.file.".bash_profile".source = "${dotfilesPath}/.bash_profile";

  # Git
  home.file.".gitconfig".source = "${dotfilesPath}/.gitconfig";
  home.file.".gitignore".source = "${dotfilesPath}/.gitignore";

  # Vim
  home.file.".vimrc".source = "${dotfilesPath}/.vimrc";
  home.file.".vim".source = "${dotfilesPath}/.vim";

  # Tmux
  home.file.".tmux.conf".source = "${dotfilesPath}/.tmux.conf";

  # Emacs/Spacemacs
  home.file.".spacemacs".source = "${dotfilesPath}/.spacemacs";
  home.activation.spacemacs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.emacs.d/.git" ]; then
      run ${pkgs.git}/bin/git clone --branch develop https://github.com/syl20bnr/spacemacs.git "$HOME/.emacs.d"
    fi
  '';

  # X11 - use thinkpad-specific files
  home.file.".Xresources".source = "${dotfilesPath}/.Xresources.thinkpad";
  home.file.".Xmodmap".source = "${dotfilesPath}/.Xmodmap";
  home.file.".xsession" = {
    source = "${dotfilesPath}/.xsession.thinkpad";
    executable = true;
  };
  home.file.".xkb".source = "${dotfilesPath}/.xkb";

  # Terminal/colors
  home.file.".dir_colors".source = "${dotfilesPath}/.dir_colors";
  home.file.".screenrc".source = "${dotfilesPath}/.screenrc";

  # XDG config dirs
  home.file.".config/awesome".source = "${dotfilesPath}/.config/awesome";
  home.file.".config/btop".source = "${dotfilesPath}/.config/btop";
  home.file.".config/udiskie".source = "${dotfilesPath}/.config/udiskie";
  home.file.".config/xfce4".source = "${dotfilesPath}/.config/xfce4";

  # GPG
  home.file.".gnupg/options".source = "${dotfilesPath}/.gnupg/options";
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
