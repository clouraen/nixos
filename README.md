# Customizing This NixOS Configuration

This guide will help you customize this NixOS configuration for your own use.

## Required Changes

1. User Configuration
   - The current configuration is set up for user "huggyturd"
   - In `flake.nix`, update the globals.user:
     ```nix
     let globals = { user = "your-username"; }; in rec {
     ```

2. Host Configuration
   - Current hosts are "home-manitoba" (NixOS) and "MMDFLQCPF9676" (macOS)
   - Choose which configuration matches your system type (Linux or macOS)
   - If creating new host:
     1. Copy template from existing host:
        - For NixOS: `cp -r hosts/home-manitoba hosts/your-hostname`
        - For macOS: `cp -r hosts/MMDFLQCPF9676 hosts/your-hostname`
     2. Update hostname in `hosts/your-hostname/default.nix`
     3. Generate hardware configuration:
        ```bash
        nixos-generate-config --show-hardware-config > hosts/your-hostname/hardware-configuration.nix
        ```
     4. Update `flake.nix` to include your new host:
        ```nix
        nixosConfigurations = {
          your-hostname = import ./hosts/your-hostname { inherit inputs globals; };
        };

        # Or for macOS:
        darwinConfigurations = {
          your-hostname = import ./hosts/your-hostname { inherit inputs globals; };
        };
        ```

3. SOPS (Secret Management)
   - If using SOPS for secret management:
     1. Generate an age key:
        ```bash
        mkdir -p /var/lib/sops-nix
        nix-shell -p age --run "age-keygen -o /var/lib/sops-nix/key.txt"
        ```
     2. Create your secrets file: `hosts/your-hostname/secrets.yaml`
   - If not using SOPS:
     1. Remove SOPS configuration from your host's `default.nix`
     2. Remove `inputs.sops-nix` from `flake.nix`
     3. Remove SOPS module imports from your configuration

4. Private Repository Access
   - Remove or update private repository reference in `flake.nix`:
     ```nix
     huggyturd-private.url = "git+file:///home/huggyturd/.dotfiles-private";
     ```

5. Hardware-Specific Settings
   - If using NVIDIA:
     - Keep NVIDIA configuration in `default.nix`
   - If not using NVIDIA:
     - Remove NVIDIA-specific settings from `default.nix`
     - Remove Wayland NVIDIA environment variables

6. Optional Modules
   - Review and modify modules in `modules/common/` and `modules/linux/` according to your needs
   - Each `.nix` file in these directories represents a different component
   - Disable unwanted modules by removing them from imports

## Using the Configuration

1. Initial Setup
   ```bash
   # Clone to /etc/nixos
   git clone <your-repo> /etc/nixos
   
   # Make your modifications following this guide
   
   # Build and activate
   nixos-rebuild switch --flake /etc/nixos#your-hostname
   ```

2. Updating
   ```bash
   # Pull updates
   cd /etc/nixos
   git pull
   
   # Rebuild
   nixos-rebuild switch --flake /etc/nixos#your-hostname
   ```

## Modules Overview

The configuration is organized into several modules:

- `modules/common/`: Cross-platform configurations
  - Base packages
  - Development tools
  - Shell configurations
  - Application configurations

- `modules/linux/`: Linux-specific configurations
  - System services
  - Desktop environment (Sway)
  - Hardware settings
  - Network configuration

Review each module's configuration by examining the respective `.nix` files and modify according to your needs.

## Common Customizations

### Package Management
- Review and modify `modules/common/base-packages.nix` for basic system packages
- Check `modules/linux/packages.nix` for Linux-specific packages
- Add or remove packages according to your needs

### Desktop Environment
- The configuration uses Sway (Wayland)
- Key configurations:
  - `modules/linux/sway.nix`: Window manager configuration
  - `modules/linux/waybar.nix`: Status bar configuration
  - `modules/linux/swaylock.nix`: Screen locking
  - `modules/linux/wldash.nix`: Application launcher

### Shell Configuration
- ZSH is the default shell
- Relevant files:
  - `modules/common/zsh/.zshrc`: Main ZSH configuration
  - `modules/common/zsh/.zsh-aliases`: Shell aliases
  - `modules/common/zsh/.zshenv`: Environment variables

### Development Tools
- Review these modules for development-related configurations:
  - `modules/common/git.nix`: Git configuration
  - `modules/common/direnv.nix`: Directory-specific environments
  - `modules/common/vscode.nix`: VS Code settings
  - `modules/common/helix.nix`: Helix editor configuration

### Network Configuration
- Check these files for network-related settings:
  - `modules/linux/network.nix`: Basic network configuration
  - `modules/linux/network-dmenu.nix`: Network manager
  - `modules/common/tailscale.nix`: VPN configuration

### Security
- Important security-related modules:
  - `modules/linux/security.nix`: System security settings
  - `modules/common/gpg.nix`: GPG configuration
  - `modules/linux/yubikey.nix`: YubiKey support
  - `modules/linux/usbguard.nix`: USB device protection

## Additional Notes

1. File Structure
   ```
   /etc/nixos/
   ├── flake.nix          # Main configuration entry
   ├── hosts/            # Host-specific configurations
   ├── modules/          # Shared modules
   │   ├── common/      # Cross-platform modules
   │   ├── linux/       # Linux-specific modules
   │   └── macos/       # macOS-specific modules
   └── overlay/         # Custom package overlays
   ```

2. Debugging Tips
   - Check logs with `journalctl -xe`
   - Test configuration changes before applying:
     ```bash
     nixos-rebuild test --flake /etc/nixos#your-hostname
     ```
   - If a build fails, try with `--show-trace` for more details

3. Maintenance
   - Regularly update your system:
     ```bash
     nix flake update
     nixos-rebuild switch --flake /etc/nixos#your-hostname
     ```
   - Keep track of your changes in a git repository
   - Backup your configuration before major changes

Remember to test your configuration changes incrementally and maintain backups of working configurations.
