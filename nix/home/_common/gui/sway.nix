{ pkgs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    systemd.enable = true;
  };

  xdg.configFile."sway/config".source = pkgs.lib.mkOverride 0 ../../../../.config/sway/config;
} 
