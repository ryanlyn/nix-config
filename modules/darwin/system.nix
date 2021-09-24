{ ... }:

{
  # Add ability to used TouchID for sudo authentication
  # Pending: https://github.com/LnL7/nix-darwin/pull/228
  # security.pam.enableSudoTouchIdAuth = true;

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
      expose-group-by-app = false;
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
      Clicking = false;
      TrackpadRightClick = true;
    };
  };
}
