{ inputs, globals, ... }:
inputs.nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";
  specialArgs = {
    util = (import ../../util);
  };
  modules = [
    ./hardware-configuration.nix
    ../../modules/linux
    ({ config, ... }: {
      personal.enable = true;

      networking.hostName = "desktop-nvidia";

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

      # Nvidia configuration
      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement = {
          enable = true;
          finegrained = true;
        };
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      # Wayland related environment variables for NVIDIA
      environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
        NIXOS_OZONE_WL = "1";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        LIBVA_DRIVER_NAME = "nvidia";
      };

      # Import home-manager modules
      home-manager.users.${globals.user}.imports = [
        inputs.sops-nix.homeManagerModules.sops
        inputs.nix-index-database.hmModules.nix-index
      ];
    })
  ];
}
