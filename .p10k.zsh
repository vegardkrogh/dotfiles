# Generated by Powerlevel10k configuration wizard
# Configuration for Powerlevel10k with a balance of information and cleanliness

# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Left prompt segments
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    dir                       # Current directory
    vcs                       # Git status
    newline                   # Newline
    prompt_char               # Prompt character
  )

  # Right prompt segments
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                    # Exit code of the last command
    command_execution_time    # Duration of the last command
    background_jobs           # Presence of background jobs
    direnv                    # direnv status
    virtualenv                # Python virtual environment
    anaconda                  # conda environment
    pyenv                     # python version from pyenv
    node_version              # Node.js version
    kubecontext               # Current kubernetes context
    terraform                 # Terraform workspace
    newline                   # Newline
    time                      # Current time
  )

  # Basic style settings
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}❯%F{cyan}❯%F{green}❯%f "

  # Prompt character
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=false

  # Directory
  typeset -g POWERLEVEL9K_DIR_BACKGROUND=blue
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=0
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

  # VCS
  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=green
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=yellow
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=red
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=0
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=0
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=0

  # Status
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=red
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=white

  # Execution time
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=yellow
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=0

  # Background jobs
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=magenta
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=0

  # Python venv/conda
  typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=green
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=0
  typeset -g POWERLEVEL9K_ANACONDA_BACKGROUND=green
  typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND=0

  # Kubernetes
  typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|flux|fluxctl|stern'
  typeset -g POWERLEVEL9K_KUBECONTEXT_BACKGROUND=cyan
  typeset -g POWERLEVEL9K_KUBECONTEXT_FOREGROUND=0

  # Time
  typeset -g POWERLEVEL9K_TIME_BACKGROUND=blue
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=0
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'

  # Transient prompt
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off

  # Instant prompt mode
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  # Hot reload
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=false

  # Icons
  typeset -g POWERLEVEL9K_VCS_GIT_ICON=$'\uF1D3 '
  typeset -g POWERLEVEL9K_VCS_GIT_GITHUB_ICON=$'\uF408 '
  typeset -g POWERLEVEL9K_VCS_GIT_GITLAB_ICON=$'\uF296 '
  typeset -g POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON=$'\uF171 '
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=$'\uF126 '
}

# Restore previous configuration options
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts' 