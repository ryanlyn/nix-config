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

      InitialKeyRepeat = 15;
      KeyRepeat = 2;

      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticInlinePredictionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = true;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      _HIHideMenuBar = false;
      "com.apple.keyboard.fnState" = true;
    };

    # dock
    dock = {
      autohide = false;
      appswitcher-all-displays = true;
      orientation = "bottom";
      tilesize = 128;
      expose-group-apps = false;
      mru-spaces = false; # automatically re-order spaces
      show-recents = false;
      showhidden = true;
    };

    # finder
    finder = {
      AppleShowAllExtensions = true;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
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

    WindowManager = {
      EnableStandardClickToShowDesktop = false;
    };

    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0;
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };
  };
}
