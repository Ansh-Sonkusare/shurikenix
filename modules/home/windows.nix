{
  config,
  lib,
  ...
}: let
  cfg = config.modules.windows;
in
  with lib; {
    options.modules.windows = {
      enable = mkEnableOption "Windows WSL integration";
      
      username = mkOption {
        type = types.str;
        default = "sonku";
        description = "Windows username for accessing Windows directories and applications";
      };
      
      vscodeEnabled = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable VS Code integration";
      };
      
      vscodePath = mkOption {
        type = types.str;
        default = "AppData/Local/Programs/'Microsoft VS Code'/bin/code";
        description = "Path to VS Code binary relative to Windows user home";
      };
    };

    config = mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.username != "";
          message = "The 'username' option in 'modules.windows' cannot be empty.";
        }
      ];
      
      # Target the home-manager shell aliases
      programs.zsh.shellAliases = mkIf config.programs.zsh.enable (
        let
          windowsHome = "/mnt/c/Users/${cfg.username}";
        in {
          # Only add the VS Code alias if vscodeEnabled is true
          code = mkIf cfg.vscodeEnabled "${windowsHome}/${cfg.vscodePath}";
        }
      );
      
      # Set the Windows home in the session variables
      home.sessionVariables = {
        WINHOME = "/mnt/c/Users/${cfg.username}";
      };
    };
  }