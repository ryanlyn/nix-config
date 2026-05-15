{ lib, ... }:

let inherit (lib) mkOption types;
in {
  options.ryan.identity = {
    profile = mkOption {
      type = types.enum [ "personal" "canva" ];
      default = "personal";
      description = "Profile identity used by shared Home Manager modules.";
    };

    gitUserName = mkOption {
      type = types.str;
      default = "ryanlyn";
      description = "Git author name.";
    };

    gitEmail = mkOption {
      type = types.str;
      default = "mailboxryanlin@icloud.com";
      description = "Git author email.";
    };

    githubUser = mkOption {
      type = types.str;
      default = "ryanlyn";
      description = "GitHub username.";
    };
  };
}
