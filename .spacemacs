;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(toml
     systemd
     python
     javascript
     lua
     markdown
     go
     html
     auto-completion
     github-copilot
     emacs-lisp
     helm
     multiple-cursors
     perl5
     puppet
     ruby
     shell-scripts
     treemacs
     yaml)

   ;; List of additional packages that will be installed without being wrapped
   ;; in a layer (generally the packages are installed only and should still be
   ;; loaded using load/require/use-package in the user-config section below in
   ;; this file). If you need some configuration for these packages, then
   ;; consider creating a layer. You can also put the configuration in
   ;; `dotspacemacs/user-config'. To use a local version of a package, use the
   ;; `:location' property: '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '()

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '(evil-unimpaired)

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."

  (setq-default
   ;; Custom startup buffer configuration
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; Custom theme configuration
   dotspacemacs-themes '(solarized-light)

   ;; Custom major mode leader key for different environments
   dotspacemacs-major-mode-emacs-leader-key (if window-system "<M-return>" "C-M-m")

   ;; Enable smartparens for programming modes
   dotspacemacs-activate-smartparens-mode t))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env))

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first.")


(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump.")


(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."

  (setq evilified-state-modes-black-list
        '(tar-mode archive-mode))

  (setq vc-follow-symlinks t)

  (with-eval-after-load 'copilot
    (define-key copilot-mode-map (kbd "TAB") #'copilot-accept-completion))

  (xterm-mouse-mode -1)
  (spacemacs/toggle-highlight-current-line-globally-off)

  ;; Do not write anything past this comment. This is where Emacs will
  ;; auto-generate custom variable definitions.
  )
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
  (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(package-selected-packages
     '(ac-ispell ace-jump-helm-line ace-link add-node-modules-path aggressive-indent
                 aio anaconda-mode auto-compile auto-highlight-symbol
                 auto-yasnippet blacken browse-at-remote bui bundler
                 centered-cursor-mode chruby clang-format clean-aindent-mode
                 color-identifiers-mode column-enforce-mode company
                 company-anaconda company-emoji company-go company-lua
                 company-plsense company-shell company-terraform company-web
                 concurrent counsel counsel-css counsel-gtags csv-mode ctable
                 cython-mode dactyl-mode dap-mode deferred define-word diminish
                 dired-quick-sort disable-mouse docker docker-tramp
                 dockerfile-mode dotenv-mode drag-stuff dumb-jump editorconfig
                 elisp-def elisp-slime-nav emmet-mode emoji-cheat-sheet-plus emr
                 enh-ruby-mode epc esh-help eshell-prompt-extras eshell-z
                 eval-sexp-fu evil-anzu evil-args evil-cleverparens
                 evil-collection evil-commentary evil-easymotion evil-ediff
                 evil-escape evil-exchange evil-goggles evil-iedit-state
                 evil-indent-plus evil-lion evil-lisp-state evil-matchit evil-mc
                 evil-nerd-commenter evil-numbers evil-org evil-surround
                 evil-textobj-line evil-tutor evil-unimpaired
                 evil-visual-mark-mode evil-visualstar expand-region eyebrowse
                 fancy-battery feature-mode fish-mode flx-ido flycheck-bashate
                 flycheck-elsa flycheck-golangci-lint flycheck-package
                 flycheck-pos-tip font-lock+ fuzzy ggtags gh-md gist
                 git-gutter-fringe+ git-link git-messenger git-timemachine
                 gitattributes-mode gitconfig-mode github-clone github-search
                 gitignore-templates gnuplot go-eldoc go-fill-struct go-gen-test
                 go-guru go-impl go-mode go-rename go-tag godoctor golden-ratio
                 google-translate grip-mode grizzl haml-mode helm-ag
                 helm-c-yasnippet helm-company helm-css-scss helm-descbinds
                 helm-flx helm-git-grep helm-gitignore helm-gtags helm-ls-git
                 helm-make helm-mode-manager helm-org helm-org-rifle
                 helm-projectile helm-purpose helm-pydoc helm-swoop helm-themes
                 helm-xref hierarchy highlight-indentation highlight-numbers
                 highlight-parentheses hl-todo htmlize hungry-delete hybrid-mode
                 impatient-mode import-js importmagic indent-guide inf-ruby
                 insert-shebang inspector ivy journalctl-mode js-doc js2-mode
                 js2-refactor json-mode json-navigator json-reformat json-snatcher
                 link-hint list-utils live-py-mode livid-mode load-env-vars
                 load-relative loc-changes lorem-ipsum lsp-docker lsp-mode
                 lsp-treemacs lua-mode macrostep markdown-mode markdown-toc
                 minitest mmm-mode monokai-theme multi-line multi-term
                 multiple-cursors mwim nameless nodejs-repl nose npm-mode
                 open-junk-file org-cliplink org-contrib org-download org-mime
                 org-pomodoro org-present org-projectile org-rich-yank
                 org-superstar orgit-forge overseer ox-gfm package-lint paradox
                 password-generator pip-requirements pipenv pippel poetry polymode
                 popwin prettier-js projectile-rails pug-mode puppet-mode py-isort
                 pyenv-mode pytest pythonic pyvenv quickrun rainbow-delimiters
                 rainbow-identifiers rainbow-mode rake rbenv realgud request
                 restart-emacs robe rspec-mode rubocop rubocopfmt ruby-hash-syntax
                 ruby-refactor ruby-test-mode ruby-tools rvm sass-mode scss-mode
                 seeing-is-believing shell-maker shell-pop simple-httpd
                 skewer-mode slim-mode smeargle solarized-theme
                 spaceline-all-the-icons sphinx-doc sql-indent string-edit
                 string-inflection swiper symbol-overlay symon systemd tablist
                 tagedit terminal-here tern test-simple toc-org toml-mode
                 transient treemacs-evil treemacs-icons-dired treemacs-magit
                 treemacs-persp treemacs-projectile undo-tree unfill use-package
                 uuidgen valign vi-tilde-fringe vimrc-mode vmd-mode
                 volatile-highlights vterm web-beautify web-completion-data
                 web-mode which-key winum writeroom-mode ws-butler xterm-color
                 yaml yaml-mode yapfify yasnippet yasnippet-snippets zenburn-theme))
   '(warning-suppress-log-types '((copilot copilot-no-mode-indent))))
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   )
  )
