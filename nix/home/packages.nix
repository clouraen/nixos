{ pkgs, push2talk, ... }: {
  services.udiskie.enable = true;

  home.packages = with pkgs; [
    acpi
    android-tools
    android-udev-rules
    asahi-bless
    bfs
    brightnessctl
    calibre
    cargo
    chromium
    dbmate
    delta
    dfrs
    doggo
    dos2unix
    dua
    earlyoom
    editorconfig-core-c
    eza
    fd
    ff2mpv-rust
    ffmpeg
    file
    firefox-wayland
    freerdp
    fzf
    gcc
    git
    glib
    go
    gocryptfs
    goimapnotify
    grim
    helvum
    inotify-tools
    iptables-nftables-compat
    isync
    jq
    kitty
    libnotify
    libreoffice
    magic-wormhole-rs
    maximbaz-scripts
    meld
    msmtp
    mysql-client
    neomutt
    netcat-openbsd
    nftables
    nix-index
    nodejs
    notmuch
    nzbget
    p7zip
    pam_u2f
    pass
    pavucontrol
    perlPackages.vidir
    pgcli
    pigz
    pinentry-gnome3
    playerctl
    postgresql_16
    progress
    pulseaudio
    push2talk
    pwgen
    python3
    qalculate-gtk
    qrencode
    rsync
    signal-desktop
    sipcalc
    slurp
    socat
    sqlite
    swappy
    swaybg
    sway-contrib.inactive-windows-transparency
    swaylock
    swayr
    syncthing
    systembus-notify
    teehee
    tig
    trash-cli
    tree
    udiskie
    unrar
    unzip
    usbguard
    vimiv-qt
    vivid
    vscode
    w3m
    wireguard-tools
    wl-clipboard
    wldash
    workstyle
    yt-dlp
    zathura
    zip
    zsh
  ];
}
