{ pkgs, lib, ... }:

{
  # git
  programs.git = {
    package = pkgs.gitFull;
    enable = true;
    userName = "ryanlyn";
    userEmail = "mailboxryanlin@icloud.com";
    ignores = [
      ".DS_Store"
      ".idea"
      ".venv"
      ".vscode"
    ];

    aliases = {
      # basic
      a = "add";
      aa = "add --all";
      pl = "pull";
      pu = "push";
      puf = "push --force-with-lease";
      s = "status";

      # commit
      c = "commit";
      cm = "commit -m";
      ca = "commit --amend";
      caa = "commit --amend --no-edit";

      # checkout
      co = "checkout";
      cob = "checkout -b";
      com = "checkout master";

      # cherrypick
      cp = "cherrypick";

      # diff
      d = "diff";
      dc = "diff --cached";
      dh = "diff HEAD";
      ds = "diff --staged";

      # reset and restore
      rh = "reset --hard";
      rh1 = "reset --hard HEAD^";
      rh2 = "reset --hard HEAD^^";
      rs = "reset --soft";
      rs1 = "reset --soft HEAD^";
      rs2 = "reset --soft HEAD^^";
      rst = "restore --staged";

      # log
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --abbrev=8";

      # common branch actions
      mm = "!set -x && git fetch origin master && git merge --no-edit origin/master";
      pg = "!git checkout green && git pull origin green";
      pm = "!git checkout master && git pull origin master";
      rbg = "!set -x && git fetch origin green && git stash && git rebase origin/green && git stash pop";
      rbi = "rebase --interactive";
      rbm = "!set -x && git fetch origin master && git rebase origin/master";

      # verbose actions
      branch-name = "symbolic-ref --short HEAD";
      del-branch = "!git checkout master && git branch -d";
      open-pr-link = "!open $(git pr-link)";
      open-repo-link = "!open $(git repo-link)";
      publish = "!git push -u origin $(git branch-name) && open $(git pr-link)";
      pr-link = "!echo $(git repo-link)/compare/master...$(git branch-name)";
      repo-link = "!git remote get-url origin | sed -n 's_.*:\\(.*\\)\\.git_https://github.com/\\1_p'";
    };

    # Enhanced diffs
    delta = {
      enable = true;
      options = {
        features = "decorations";

        syntax-theme = "Monokai Extended";
        side-by-side = true;
        navigate = true;
        inspect-raw-lines = true; # needed for coloredMove

        decorations = {
          line-numbers = true;
          relative-paths = true;
          keep-plus-minus-markers = true;
          hyperlinks = false;
        };
      };
    };

    extraConfig = {
      core.editor = "nvim";
      diff.colorMove = "default";
      github.user = "ryanlyn";
      merge.conflictStyle = "diff3";
      pull.ff = "only";
      rebase.autosquash = true;
      rerere.enabled = true;
    };
  };

  # github
  programs.gh = {
    enable = true;
    settings = {
      gitProtocol = "ssh";
      editor = "nvim";
      aliases = {
        pco = "pr checkout";
        pck = "pr checks";
        pcl = "pr close";
        pcr = "pr create";
        pd = "pr diff";
        pl = "pr list";
        pm = "pr merge";
        pv = "pr view";
        pvw = "pr view --web";
        prs = "pr list -A ryanlyn";
      };
    };
  };
}
