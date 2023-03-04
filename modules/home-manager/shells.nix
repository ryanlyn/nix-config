{ config, pkgs, lib, ... }:
{
  # external themes
  programs.starship = {
    enable = false;
    enableZshIntegration = false;

    # See docs here: https://starship.rs/config/
    # Symbols config configured in Flake.
    settings = {
      battery.display.threshold = 25; # display battery information if charge is <= 25%
      directory.fish_style_pwd_dir_length = 1; # turn on fish directory truncation
      directory.truncation_length = 2; # number of directories not to truncate
      memory_usage.disabled = true; # because it includes cached memory it's reported as full a lot
    };
  };

  # zsh
  home.packages = [
    # powerlevel10k font
    pkgs.meslo-lgs-nf

    pkgs.fzf-zsh
    pkgs.nix-zsh-completions
    pkgs.oh-my-zsh
    # pkgs.pure-prompt
    pkgs.zsh
    pkgs.zsh-autosuggestions
    pkgs.zsh-nix-shell
    pkgs.zsh-powerlevel10k
    pkgs.zsh-syntax-highlighting
  ];

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    autocd = true;

    # pure prompt
    # initExtraBeforeCompInit = "autoload -U promptinit && promptinit && prompt pure";
    completionInit = "autoload -U compinit && compinit";
    initExtra = ''
      # powerlevel10k theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ${config.xdg.configHome}/p10k.zsh ]] || source ${config.xdg.configHome}/p10k.zsh
    '';
    envExtra = ''
      # nix
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi

      # home-manager
      . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh 

      # homebrew
      # nix-darwin bug with apple silicon - requires homebrew to be installed and linked manually
      if [[ $OSTYPE == darwin* ]]; then 
          eval "$(/opt/homebrew/bin/brew shellenv)"
      fi

      # direnv
      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"

      # google-cloud-sdk
      export PATH="$HOME/google-cloud-sdk/bin:$PATH"

      # >>> conda initialize >>>
      __conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
      if [ $? -eq 0 ]; then
          eval "$__conda_setup"
      else
          if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
              . "$HOME/miniconda3/etc/profile.d/conda.sh"
          else
              export PATH="$HOME/miniconda3/bin:$PATH"
          fi
      fi
      unset __conda_setup
      # <<< conda initialize <<<
    '';
    loginExtra = ''
      neofetch
    '';

    sessionVariables = {
      EDITOR = "nvim";
      LC_CTYPE = "en_AU.UTF-8";
      LESSCHARSET = "utf-8";
      TERM = "xterm-256color";
    };

    shellAliases = {
      garbage = "nix-collect-garbage -d && docker image prune --force";
      la = "exa -la";
      ll = "exa -l";
      ls = "exa";
      nix-ds = ''darwin-rebuild switch -I "darwin-config=$HOME/nix-config/darwin.nix"'';
      nix-hs = "home-manager -f $HOME/nix-config/home.nix switch";
    };

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "0c36bdcf6a80ec009280897f07f56969f94d377e";
          sha256 = "0ymp9ky0jlkx9b63jajvpac5g3ll8snkf8q081g0yw42b9hwpiid";
        };
      }
    ];

    oh-my-zsh = {
      enable = true;
      theme = "";
      # pure prompt config:
      # extraConfig = "zstyle :prompt:pure:git:stash show yes";
      plugins = [
        "git"

        # fzf not needed since automatically installed:
        # "fzf" 
      ];
    };

    history = {
      extended = true;
      expireDuplicatesFirst = true;
    };
  };
}
