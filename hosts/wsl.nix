{
  pkgs,
  inputs,
  username,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  home-manager.users.${username} = {
    enableNodeJs = true;
    enableNodeJsPkgs = true;
  };

  environment.systemPackages = with pkgs; [usbutils coreutils];
  systemd.user = {
    paths.vscode-remote-workaround = {
      wantedBy = ["default.target"];
      pathConfig.PathChanged = "%h/.vscode-server/bin";
    };
    services.vscode-remote-workaround.script = ''
      for i in ~/.vscode-server/bin/*; do
        if [ -e $i/node ]; then
          echo "Fixing vscode-server in $i..."
          ln -sf ${pkgs.nodejs_18}/bin/node $i/node
        fi
      done
    '';
  };

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.user.default = username;
    defaultUser = username;
    startMenuLaunchers = true;

    interop.register = true;
    useWindowsDriver = true;
    usbip = {
      enable = true;
      autoAttach = ["2-2"];
    };
  };
}
