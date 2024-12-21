{
  # version of *installation*, do not edit on installed system!
  system.stateVersion = "25.05";

  imports = [
    ../common
    ./android.nix
    ./bluetooth.nix
    ./boot.nix
    ./btrfs.nix
    ./crypttab.nix
    ./cursor.nix
    ./dbus.nix
    ./docker.nix
    ./earlyoom.nix
    ./flipper.nix
    ./fstrim.nix
    ./i18n.nix
    ./keyboard.nix
    ./network.nix
    ./network-dmenu.nix
    ./ozone.nix
    ./packages.nix
    ./polkit.nix
    ./power.nix
    ./security.nix
    ./ssh.nix
    ./sudo.nix
    ./swap.nix
    ./sway.nix
    ./swaylock.nix
    ./swaync.nix
    ./swayr.nix
    ./systemd-services.nix
    ./systemd.nix
    ./udisks2.nix
    ./usbguard.nix
    ./users.nix
    ./waybar.nix
    ./wldash.nix
    ./wluma.nix
    ./workstyle.nix
    ./xdg.nix
    ./yubikey.nix
  ];
}
