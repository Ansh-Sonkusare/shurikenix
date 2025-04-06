{
  self,
  inputs,
  username,
  ...
}: {
  flake.deploy.nodes = let
    deployConfig = name: host: system: cfg: {
      hostname = host;
      profiles.system = {
        user = "root";
        sshUser = username;
        path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.${name};
        magicRollback = cfg.magicRollback or true;
        sshOpts = cfg.sshOpts or [];
      };
    };
  in {
 #   wsl = deployConfig "laptop" "laptop" "x86_64-linux" {
 #     magicRollback = false;
 #     sshOpts = ["-t"];
 #   };
  };
  flake.checks = builtins.mapAttrs (_system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

}
