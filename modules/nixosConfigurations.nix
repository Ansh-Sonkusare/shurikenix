{
  inputs,
  username,

  ...
}: {
  flake.nixosConfigurations = let
    systemConfig = system: modules:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs username ;};
        inherit system;
        modules =
          [
            ./sops.nix
            ./system.nix
            ./home
          ]
          ++ modules;
      };
  in {
       wsl = systemConfig "x86_64-linux" [../hosts/wsl.nix];
  };
}
