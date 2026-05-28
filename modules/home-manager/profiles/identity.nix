{ lib, ... }:

let inherit (lib) mkOption types;
in {
  options.local.identity = {
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
