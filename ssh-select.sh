#!/usr/bin/env zsh
# Source this script to pick an SSH key and load it session-wide.
# Usage: source ~/.ssh/ssh-select.sh   (or via alias: sshkey)

SSH_DIR="$HOME/.ssh"

# Collect private keys (exclude .pub, config, known_hosts, authorized_keys)
keys=()
while IFS= read -r f; do
  keys+=("$f")
done < <(find "$SSH_DIR" -maxdepth 1 -type f \
  ! -name "*.pub" \
  ! -name "config" \
  ! -name "known_hosts" \
  ! -name "authorized_keys" \
  ! -name "ssh-select.sh" \
  | sort)

if [[ ${#keys[@]} -eq 0 ]]; then
  echo "No SSH keys found in $SSH_DIR"
  return 1 2>/dev/null || exit 1
fi

echo ""
echo "Available SSH keys:"
for i in {1..${#keys[@]}}; do
  echo "  [$i] ${keys[$i]}"
done
echo ""

read -r "choice?Select key [1-${#keys[@]}]: "

if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#keys[@]} )); then
  echo "Invalid selection."
  return 1 2>/dev/null || exit 1
fi

selected="${keys[$choice]}"

# Start ssh-agent if not already running
if [[ -z "$SSH_AUTH_SOCK" ]]; then
  eval "$(ssh-agent -s)" > /dev/null
fi

# Clear previously loaded keys and load the selected one
ssh-add -D 2>/dev/null
ssh-add "$selected"

echo ""
echo "Active key: $selected"
