{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell.url = "github:numtide/devshell";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    deploy-rs.url = "github:serokell/deploy-rs";
    sops-nix.url = "github:Mic92/sops-nix";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs: let
    username = "teak";
     in
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devshell.flakeModule
        inputs.pre-commit-hooks.flakeModule
        (import ./modules/deploy.nix {inherit self inputs username;})
        (import ./modules/nixosConfigurations.nix {inherit inputs username ;})
      ];
      systems = ["x86_64-linux" "aarch64-darwin"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        formatter = pkgs.alejandra;
        pre-commit.settings.hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
          deadnix.settings.noUnderscore = true;
        };
        packages.default = pkgs.hello;
        devshells.default = {
          packages = with pkgs; [nil deadnix alejandra];
        };
      };
      flake = {
      };
    };
}
