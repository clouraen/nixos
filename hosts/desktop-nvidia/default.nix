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
          "nvidia.NVreg_PreserveVideoMemoryAllocations=1"  # Prevent black screen
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
      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };

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

      # Configure fonts with proper scaling
      fonts.fontconfig.enable = true;

      # Force Wayland usage
      services.xserver = {
        enable = true;  # Needed for login manager
        displayManager = {
          gdm = {
            enable = true;
            wayland = true;  # Force Wayland usage
          };
          defaultSession = "sway";  # Always start sway
        };
      };

      # Ensure XWayland is available for compatibility
      programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraSessionCommands = ''
          # Force electron apps to use wayland
          export NIXOS_OZONE_WL="1"
        '';
        extraOptions = ["--unsupported-gpu"];  # For better NVIDIA support
      };

      # Force Wayland for all applications
      environment = {
        sessionVariables = {
          # Wayland specific
          WLR_NO_HARDWARE_CURSORS = "1";      # Fix cursor issues
          WLR_RENDERER = "vulkan";            # Use Vulkan renderer
          NIXOS_OZONE_WL = "1";               # Electron apps Wayland support
          GBM_BACKEND = "nvidia-drm";         # Hardware acceleration
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          LIBVA_DRIVER_NAME = "nvidia";
          WLR_DRM_DEVICES = "/dev/dri/card0"; # Specify GPU device
          XDG_SESSION_TYPE = "wayland";       # Force Wayland session
          MOZ_ENABLE_WAYLAND = "1";           # Firefox Wayland support
          QT_QPA_PLATFORM = "wayland";        # Qt apps on Wayland
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # Native Qt decorations
          SDL_VIDEODRIVER = "wayland";        # SDL apps on Wayland
          _JAVA_AWT_WM_NONREPARENTING = "1"; # Fix Java apps on Wayland
          XDG_CURRENT_DESKTOP = "sway";       # Set current desktop
          XDG_SESSION_DESKTOP = "sway";       # Set session desktop
          GTK_USE_PORTAL = "1";              # Use system file picker
        };
        
        systemPackages = with pkgs; [
          # Wayland utilities
          wayland-utils
          wl-clipboard
          wlr-randr
          qt6.qtwayland
          glfw-wayland
          xwayland
        ];
      };

      # Additional Wayland configurations
      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

      # Force Wayland for Firefox
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-wayland;
      };

      system.stateVersion = "23.11";
    })
  ];
}
