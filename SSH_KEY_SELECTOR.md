# SSH Key Selector

A lightweight zsh script that lets you interactively pick which SSH key to use in your current terminal session.

---

## Prerequisites

| Platform | Requirement |
|----------|-------------|
| macOS | zsh (default since macOS Catalina), OpenSSH (built-in) |
| Linux | zsh (`sudo apt install zsh` or `sudo dnf install zsh`), OpenSSH |
| Windows | WSL2 with zsh, or Git Bash (see notes below) |

---

## Setup

### macOS / Linux

1. **Copy the script to your `.ssh` folder:**
   ```bash
   cp ssh-select.sh ~/.ssh/ssh-select.sh
   chmod +x ~/.ssh/ssh-select.sh
   ```

2. **Add the alias to your shell config:**

   For zsh (`~/.zshrc`):
   ```bash
   echo 'alias sshkey="source ~/.ssh/ssh-select.sh"' >> ~/.zshrc
   source ~/.zshrc
   ```

   For bash (`~/.bashrc` or `~/.bash_profile`):
   ```bash
   echo 'alias sshkey="source ~/.ssh/ssh-select.sh"' >> ~/.bashrc
   source ~/.bashrc
   ```

   > **Note:** The alias must use `source` (not just execute) so the loaded SSH key carries over to your current shell session.

---

### Windows (WSL2)

1. Open your WSL2 terminal (Ubuntu, Debian, etc.)

2. Install zsh if not already installed:
   ```bash
   sudo apt update && sudo apt install zsh -y
   ```

3. Follow the same macOS/Linux steps above inside the WSL2 terminal.

4. Your Windows SSH keys are typically at `C:\Users\<you>\.ssh\` — in WSL2 they're accessible at `/mnt/c/Users/<you>/.ssh/`. You can copy them:
   ```bash
   cp /mnt/c/Users/<you>/.ssh/id_ed25519 ~/.ssh/
   chmod 600 ~/.ssh/id_ed25519
   ```

> **Git Bash on Windows:** `source` works in Git Bash but process substitution `< <(...)` may not. WSL2 is strongly recommended.

---

## Usage

In any terminal, simply run:

```bash
sshkey
```

You will see a list like:

```
Available SSH keys:
  [1] /Users/you/.ssh/id_ed25519
  [2] /Users/you/.ssh/id_ed25519_gitlab

Select key [1-2]:
```

Type the number and press Enter. The key is loaded into `ssh-agent` for the rest of your session.

---

## How to Generate SSH Keys

```bash
# Personal (e.g. GitHub)
ssh-keygen -t ed25519 -C "you@email.com" -f ~/.ssh/id_ed25519

# Work (e.g. GitLab)
ssh-keygen -t ed25519 -C "you@company.com" -f ~/.ssh/id_ed25519_gitlab
```

---

## Using the Selected Key to Clone

After running `sshkey`, clone as normal — the selected key is already active:

```bash
git clone git@github.com:org/repo.git
git clone git@gitlab.com:org/repo.git
```

---

## Verify Which Key is Active

```bash
ssh-add -l
```

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `command not found: sshkey` | Run `source ~/.zshrc` or open a new terminal |
| `No SSH keys found` | Make sure keys exist in `~/.ssh/` without a `.pub` extension |
| `Could not open a connection to your authentication agent` | Run `eval "$(ssh-agent -s)"` then try `sshkey` again |
| Permission denied on key | Run `chmod 600 ~/.ssh/<keyname>` |
