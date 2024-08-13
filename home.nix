{ config, pkgs, ... }:

{
  # TODO please change the username & home directory to your own
  home.username = "budchris";
  home.homeDirectory = "/home/budchris";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;
  home.file.".tmux.conf".source = ./dotfiles/tmux/tmux.conf;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # link all files in `./dotfiles/nvim` to `~/.config/nvim`
  home.file.".config/nvim" = {
    source = ./dotfiles/nvim;
    recursive = true;   # link recursively
    executable = true;  # make all files executable
  };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    # my shieeeeet
    ## Fonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })  
    ## CLI Tools 
    cowsay
    file
    fortune
    fzf # A command-line fuzzy finder
    gawk
    gnupg
    gnused
    gnutar
    htop
    jq # A lightweight and flexible command-line JSON processor
    lazygit
    lsof # list open files
    mc
    neofetch
    nnn # terminal file manager
    ripgrep # recursively searches directories for a regex pattern
    stow
    tmux
    tokei
    tree
    which
    # archives
    p7zip
    unzip
    xz
    zip
    ## devops
    docker
    docker-compose
    kubectl
    nmap # A utility for network discovery and security auditing
    terraform
    ## dev environments
    conda # linux only
    nodejs
    yarn
    ## testing
    chromedriver
    ## cloud platforms
    awscli2
    azure-cli
    google-cloud-sdk
    ## GUI Apps
    _1password
    nextcloud-client # linux only
    obsidian #linux64 only 
    picard
    vlc #linux only
    wireshark
    ### Web Browsers for Work
    brave # linux only 
    google-chrome
    microsoft-edge
    
    # Extra stuff recommended
    # utils
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    ipcalc  # it is a calculator for the IPv4/v6 addresses
    # misc
    zstd
    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor
    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal
    # tops
    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
    # set some aliases, feel free to add more or remove some
    shellAliases = {
      k = "kubectl";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };

  # New Zsh configuration
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "z" "sudo" "kubectl" ];
    };
    initExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      alias k="kubectl"
    '';
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Solito Reyes III";
    userEmail = "solrey3@solrey3.com";
  };

  # Github CLI
  programs.gh = {
    enable = true;
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      font.normal = { 
        family = "JetBrainsMono Nerd Font";
        style = "Regular";
      };
      font.size = 12;
      env.TERM = "xterm-256color";
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
      window.padding = { 
        x = 24;
        y = 24; 
      };
      window.decorations = "Full";
      window.opacity = 0.8;
    };
  };

  # modern vim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "[░▒▓](#a3aed2)[  ](bg:#a3aed2 fg:#090c0c)$hostname[](bg:#769ff0 fg:#a3aed2)$directory[](fg:#769ff0 bg:#394260)$git_branch$git_status[](fg:#394260 bg:#212736)$nodejs$rust$golang$php$gcloud$conda[](fg:#212736 bg:#1d2230)$time[ ](fg:#1d2230)\n$character";

      hostname = {
        ssh_only = false;
        style = "bg:#a3aed2 fg:#090c0c";
        format = "[$hostname]($style)";
      };

      directory = {
        style = "fg:#e3e5e5 bg:#769ff0";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
      };

      git_status = {
        style = "bg:#394260";
        format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      gcloud = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($account@$project) ](fg:#769ff0 bg:#212736)]($style)";
      };

      conda = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol $environment ](fg:#769ff0 bg:#212736)]($style)";
      };

      time = {
        disabled = false;
        time_format = "%F %T";
        style = "bg:#1d2230";
        format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
      };
    };
  };


  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
