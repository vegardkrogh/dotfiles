# Cheatsheet

## Git Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `gs` | `git status` | Check status |
| `ga` | `git add` | Add files to staging |
| `gc` | `git commit` | Commit changes |
| `gcm` | `git commit -m` | Commit with message |
| `gca` | `git commit --amend --no-edit` | Amend commit without edit |
| `gco` | `git checkout` | Checkout branch or files |
| `gb` | `git branch` | List branches |
| `gp` | `git push` | Push to remote |
| `gpl` | `git pull` | Pull from remote |
| `gl` | `git log --oneline --graph --decorate` | View commit history |
| `gd` | `git diff` | Show changes |
| `gst` | `git stash` | Stash changes |
| `gsta` | `git stash apply` | Apply stashed changes |
| `gstl` | `git stash list` | List stashes |

## Docker Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `d` | `docker` | Docker command |
| `dc` | `docker compose` | Docker Compose command |
| `up` | `docker compose up` | Start containers |
| `down` | `docker compose down` | Stop containers |
| `ps` | `docker compose ps` | List containers |
| `logs` | `docker compose logs -f` | Follow logs |
| `dps` | `docker ps` | List Docker containers |
| `di` | `docker images` | List Docker images |
| `drmi` | `docker rmi` | Remove Docker images |
| `drm` | `docker rm` | Remove Docker containers |
| `dexec` | `docker exec -it` | Execute command in container |

## Kubernetes Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `k` | `kubectl` | Kubectl shorthand |
| `kgp` | `kubectl get pods` | Get pods |
| `kgs` | `kubectl get services` | Get services |
| `kgd` | `kubectl get deployments` | Get deployments |
| `kgn` | `kubectl get nodes` | Get nodes |
| `ka` | `kubectl apply -f` | Apply resource |
| `kd` | `kubectl delete` | Delete resource |
| `kl` | `kubectl logs` | View logs |
| `ke` | `kubectl exec -it` | Execute in pod |

## Terraform Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `tf` | `terraform` | Terraform command |
| `tfi` | `terraform init` | Initialize |
| `tfp` | `terraform plan` | Plan changes |
| `tfa` | `terraform apply` | Apply changes |
| `tfd` | `terraform destroy` | Destroy resources |

## Ansible Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `a` | `ansible` | Ansible command |
| `ap` | `ansible-playbook` | Run playbook |
| `al` | `ansible-lint` | Lint playbooks |
| `ag` | `ansible-galaxy` | Manage roles |
| `av` | `ansible-vault` | Encrypt data |
| `ai` | `ansible-inventory` | Manage inventory |

## Navigation Shortcuts

| Command | Description |
|---------|-------------|
| `..` | Go up one directory |
| `...` | Go up two directories |
| `....` | Go up three directories |
| `.....` | Go up four directories |
| `~` | Go to home directory |
| `cd -` | Go to previous directory |

## Vim Cheatsheet

| Key | Action |
|-----|--------|
| `dd` | Delete line |
| `yy` | Copy line |
| `p` | Paste |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `/pattern` | Search for pattern |
| `:w` | Save |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |

## Tmux Cheatsheet

| Key | Action |
|-----|--------|
| `Ctrl+b c` | Create new window |
| `Ctrl+b n` | Next window |
| `Ctrl+b p` | Previous window |
| `Ctrl+b %` | Split vertically |
| `Ctrl+b "` | Split horizontally |
| `Ctrl+b d` | Detach from session |
| `Ctrl+b x` | Kill pane |
| `tmux a` | Attach to session |
| `tmux ls` | List sessions |

## ZSH Features

| Key/Command | Description |
|-------------|-------------|
| `Tab` | Auto-complete |
| `Ctrl+r` | Search command history |
| `!!` | Repeat last command |
| `!$` | Last argument of previous command |
| `Alt+.` | Insert last argument of previous command |

## Documentation Aliases

| Alias | Description |
|-------|-------------|
| `dotdoc` | Show main documentation |
| `dotinstall` | Show installation instructions |
| `dotconfig` | Show configuration guide |
| `dotcheat` | Show this cheatsheet |
| `dotaliases` | Show all available aliases |
| `dothelp` | Show documentation in terminal format 