# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Setup audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Fonts
  fonts.packages = with pkgs; [
  nerd-fonts.noto
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.clay = {
    isNormalUser = true;
    description = "Clayton Hill";
    extraGroups = [ "networkmanager" "wheel" "seat" ];
    packages = with pkgs; [];
  };

#  -----------------
# | NVIDIA SETTINGS |
#  -----------------

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ 
    "modesetting"
    "nvidia"
  ];
  hardware.nvidia.open = false;
  hardware.nvidia.modestting.enable = true;
# ---run 'nix shell nixpkgs#pciutils -c lspci -D -d ::03xx---
  hardware.nvidia.prime = {
    offload.enable = true;
    
    intelBusId = "PCI:0@0:2:0";
    nvidiaBusId = "PCI:1@0:0:0";
  };

# -----------------
#| LAPTOP SETTINGS |
# -----------------
  
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "lock";
    HandleLidSwitchDocked = "ignore";
  };

# ---------------------------
#| APPLICATIONS AND PACKAGES |
# ---------------------------

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Programs
  programs.hyprland = {
    enable = true;
    withUWSM = true; #BROKEN with ly
    xwayland.enable = true;
  };

  programs.steam.enable = true;
  programs.yazi.enable = true;
  programs.firefox.enable = true;
  programs.waybar.enable = true;
  programs.hyprlock.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    kitty
    discord
    prismlauncher
    btop
    lutris
    picard
  #-hypr_stuff-
    wofi
    mako
    hyprpolkitagent
    hyprpaper
  ];

#  ----------
# | SERVICES |
#  ----------

  #services.displayManager.ly.enable = true;
  #services.displayManager.emptty.enable = true;
  #services.displayManager.lemurs.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.xserver.enable = true;
  services.hypridle.enable = true;

#  ----------------
# | OTHER SETTINGS |
#  ----------------

 xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };



#  ---------------
# | ENV VARIABLES |
#  ---------------
  environment.sessionVariables = {
     NIXOS_OZONE_WL = "1";
     };







  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
