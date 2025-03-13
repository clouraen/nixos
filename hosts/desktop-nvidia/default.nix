{ inputs, globals, ... }:
let 
  system = "x86_64-linux";
in
inputs.nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    ./hardware-configuration.nix
    ({ config, pkgs, ... }: {
      # Basic system configuration
      networking.hostName = "desktop-nvidia";
      
      # Set user configuration
      users.users.root = {
        password = "nixos";
      };

      # Allow unfree packages (needed for NVIDIA drivers)
      nixpkgs.config.allowUnfree = true;

      # Disable ACPI errors
      boot = {
        kernelParams = [
          "acpi=off"              # Disable ACPI completely
          "noacpi"                # Disable ACPI for IRQ handling
          "pci=noacpi"            # Disable ACPI for PCI
          "quiet"                 # Reduce kernel output
          "loglevel=3"           # Set lower log level
        ];
        
        # Bootloader configuration
        loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 10;
          };
          efi.canTouchEfiVariables = true;
        };
        initrd.systemd.enable = true;
      };

      # Graphics configuration
      hardware.graphics.enable = true;  # New name for opengl.enable
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement = {
          enable = false;  # Disabled since we're using ACPI=off
          finegrained = false;
        };
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      # Configure fonts with proper scaling
      fonts.fontconfig.enable = true;

      # X server configuration
      services.xserver = {
        enable = true;
        videoDrivers = [ "nvidia" ];
      };

      # Wayland related environment variables for NVIDIA
      environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
        NIXOS_OZONE_WL = "1";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        LIBVA_DRIVER_NAME = "nvidia";
      };

      system.stateVersion = "23.11";
    })
  ];
}
