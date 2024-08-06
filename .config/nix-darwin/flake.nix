{
  description = "Liam's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
    let
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = [ pkgs.vim pkgs.glow pkgs.nixfmt ];

        # Auto upgrade nix package and the daemon service.
        services = { nix-daemon.enable = true; };
        nix = {
          configureBuildUsers = true;
          package = pkgs.nix;

          # Necessary for using flakes on this system.
          settings.experimental-features = "nix-command flakes";
        };

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs = {
          zsh.enable = true; # default shell on catalina
          direnv = {
            enable = true;
            loadInNixShell = true;
          };
        };

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "x86_64-darwin";

        # Enable sudo touch id authentication.
        security.pam.enableSudoTouchIdAuth = true;

        users.users.dt41nb.home = "/Users/dt41nb";

        system.defaults = {
          menuExtraClock.Show24Hour = true;
          dock = {
            autohide = true;
            autohide-delay = 0.1;
            autohide-time-modifier = 0.2;
            mru-spaces = false;
          };
          finder = {
            AppleShowAllExtensions = true;
            FXPreferredViewStyle = "clmv";
            ShowPathbar = false;
            _FXShowPosixPathInTitle = true;
          };
          loginwindow.LoginwindowText = "Liam's Mac";
          screencapture.location = "~/Screenshots";
        };
        # Homebrew needs to be installed on its own!
        homebrew = {
          enable = true;
          casks = [ "amethyst" "kitty" "git-credential-manager" ];
          brews = [ "imagemagick" ];
          taps = [ "homebrew/services" ];
        };
      };
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#APM3LP4X57GX3DK
      darwinConfigurations."APM3LP4X57GX3DK" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.dt41nb = import ./home.nix;
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."APM3LP4X57GX3DK".pkgs;
    };
}
