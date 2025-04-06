{
  config,
  lib,
  pkgs,
  inputs,
  username,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.default];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit username;
   
    };
    sharedModules = [
      {
        imports = [
          inputs.sops-nix.homeManagerModules.sops
          ./shell.nix
          ./code.nix
          ./windows.nix
        ];

        home = {
          inherit username;
          homeDirectory = "/home/${username}";
          stateVersion = lib.mkDefault config.system.stateVersion;
          packages = with pkgs; [curl wget zip unzip];
        };

        programs.home-manager.enable = true;
        services.ssh-agent.enable = true;
        sops = {
          defaultSopsFile = ../../secrets/default.yaml;
          age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
        };
      }
    ];
  };
}
