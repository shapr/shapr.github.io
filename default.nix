{ compiler ? "ghc8107" }:

let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };

  gitignore = pkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];

  myHaskellPackages = pkgs.haskell.packages.${compiler}.override {
    overrides = hself: hsuper: {
      "myblog" = hself.callCabal2nix "myblog" (gitignore ./.) { };
    };
  };

  shell = myHaskellPackages.shellFor {
    packages = p: [ p."myblog" ];
    buildInputs = [
      myHaskellPackages.haskell-language-server
      pkgs.haskellPackages.cabal-install
      pkgs.haskellPackages.ghcid
      pkgs.haskellPackages.ormolu
      pkgs.haskellPackages.hlint
      pkgs.haskellPackages.hasktags
      pkgs.niv
      pkgs.nixpkgs-fmt
    ];
    withHoogle = true;
  };

  exe = pkgs.haskell.lib.justStaticExecutables (myHaskellPackages."myblog");

  docker = pkgs.dockerTools.buildImage {
    name = "myblog";
    config.Cmd = [ "${exe}/bin/myblog" ];
  };
in {
  inherit shell;
  inherit exe;
  inherit docker;
  inherit myHaskellPackages;
  "myblog" = myHaskellPackages."myblog";
}
