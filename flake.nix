{
  description = "cwage dotfiles as Home Manager module";

  outputs = { self, ... }: {
    homeManagerModules.default = import ./home;
  };
}
