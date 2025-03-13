{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices."crypted" = {
        device = "/dev/sda2";
        preLVM = true;
        allowDiscards = true;
      };
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/129eaa34-abd5-45c6-8665-22aa02fb78d6";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/C548-801A";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/ac8727aa-7e23-43ec-8126-283adc782d92";
      fsType = "ext4";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/2bc8aedf-6879-40a3-9a6c-0178500e2b8c"; }
  ];

  # Enable trim support for SSD
  services.fstrim.enable = true;

  # High-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
