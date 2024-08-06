# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
  home.username = "dt41nb";
  home.homeDirectory = "/Users/dt41nb";
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = [ ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  # home.file = {
  #   # ".zshrc".source = ~/.dotfiles/.zshrc;
  #   # ".config/wezterm".source = ~/.dotfiles/wezterm;
  #   ".config/skhd".source = ~/.dotfiles/.config/skhd;
  #   # ".config/starship".source = ~/.dotfiles/starship;
  #   # ".config/zellij".source = ~/.dotfiles/zellij;
  #   # ".config/nvim".source = ~/.dotfiles/nvim;
  #   # ".config/nix".source = ~/.dotfiles/nix;
  #   # ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
  # };

  home.sessionVariables = { };

  home.sessionPath = [ "/run/current-system/sw/bin" "$HOME/.nix-profile/bin" ];
  programs.home-manager.enable = true;
  # programs.zsh = {
  #   enable = true;
  #   initExtra = ''
  #     # Add any additional configurations here
  #     export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
  #     if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  #       . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  #     fi
  #   '';
  # };
}
