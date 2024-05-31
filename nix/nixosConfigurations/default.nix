{ pkgs, ... }:

let
  overlay = self: super: {
    input-fonts = super.input-fonts.overrideAttrs (oldAttrs: {
      src = super.fetchzip {
        # This URL is too long for fetchzip, and returns non-reproducible zips with new sha256 every time ☹️
        # url = "https://input.djr.com/build/?customize&fontSelection=fourStyleFamily&regular=InputMonoNarrow-Regular&italic=InputMonoNarrow-Italic&bold=InputMonoNarrow-Bold&boldItalic=InputMonoNarrow-BoldItalic&a=0&g=0&i=serifs_round&l=serifs_round&zero=slash&asterisk=height&braces=0&preset=default&line-height=1.1&accept=I+do&email=";
        url = "https://maximbaz.com/input-fonts.zip";
        sha256 = "09qfb3h2s1dlf6kn8d4f5an6jhfpihn02zl02sjj26zgclrp6blc";
        stripRoot = false;
      };
    });
  };
in
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
    extraModprobeConfig = ''
      options hid_apple swap_opt_cmd=1 swap_fn_leftctrl=1 iso_layout=1
    '';
    initrd.systemd.enable = true;
  };

  sound.enable = true;

  time.timeZone = "Europe/Copenhagen";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "en_DK.UTF-8/UTF-8"
    ];
  };

  networking = {
    hostName = "home-manitoba";
    useDHCP = false;
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # nix = {
  #     package = pkgs.nixVersions.git;
  #     channel.enable = false;
  #     settings = {
  #       substituters = [ "https://nix-community.cachix.org" ];
  #       trusted-public-keys = [
  #         "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #       ];
  #       experimental-features = [ "nix-command" "flakes" ];
  #       auto-optimise-store = true;
  #     };
  #   };

  nixpkgs = {
    config = {
      allowUnfree = true;
      input-fonts.acceptLicense = true;
    };
    overlays = [ overlay ];
  };

  users.users.maximbaz = {
    password = "CHANGEME";
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
    shell = pkgs.zsh;
  };

  environment = {
    systemPackages = with pkgs; [
      git
      helix
      curl
      wget
    ];

    etc.crypttab.text = ''
      backup_sandisk  LABEL=backup_sandisk    none    noauto,fido2-device=auto
      backup_wd       LABEL=backup_wd         none    noauto,fido2-device=auto
    '';

    sessionVariables.NIXOS_OZONE_WL = "1";

    variables.EDITOR = "hx";
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  programs.waybar.enable = true;
  programs.zsh.enable = true;
  programs.adb.enable = true;

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam = {
      services.sudo.u2fAuth = true;
      services.polkit-1.u2fAuth = true;
      u2f.cue = true;
    };
  };

  services = {
    #   upower.enable = true;
    #   fstrim.enable = true;
    #   timesyncd.enable = true;
    udisks2.enable = true;
    getty.autologinUser = "maximbaz";
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 4 * 1024;
  }];


  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  systemd = {
    network = {
      enable = true;
      # wait-online.enable = false;
      networks = {
        "20-wireless" = {
          matchConfig.Name = "wlan0";
          networkConfig.DHCP = "yes";
          dhcpConfig.RouteMetric = 20;
        };
        "50-wired" = {
          matchConfig.Name = "enp*";
          networkConfig.DHCP = "yes";
          dhcpConfig.RouteMetric = 50;
        };
      };
    };

    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # xdg = {
  #   portal = {
  #     enable = true;
  #     extraPortals = with pkgs; [
  #       xdg-desktop-portal-gtk
  #       xdg-desktop-portal-wlr
  #     ];
  #   };


  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  system.stateVersion = "24.05";
}
