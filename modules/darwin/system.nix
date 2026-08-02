{ ... }:

{
  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
    reattach = true;
  };

  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 7;
      Hour = 3;
      Minute = 15;
    };
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;

  programs.nix-index.enable = true;

  # keyboard
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
    # userKeyMapping = [];
  };

  system.defaults = {
    # general system settings
    NSGlobalDomain = {
      # units
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      AppleShowScrollBars = "Automatic";
      AppleTemperatureUnit = "Celsius";

      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = true;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      _HIHideMenuBar = false;
    };

    # dock
    dock = {
      autohide = false;
      orientation = "left";
      tilesize = 128;
      expose-group-apps = false;
      mru-spaces = false; # automatically re-order spaces
      showhidden = true;
    };

    # finder
    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
    };

    # login
    loginwindow = {
      GuestEnabled = false;
      DisableConsoleAccess = true;
    };

    # spaces
    spaces = {
      spans-displays = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };
  };
}
