#!/usr/bin/env bash
# Source this script to pick an SSH key and load it session-wide.
# Usage: source ~/.ssh/ssh-select-bash.sh   (or via alias: sshkey)

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
  ! -name "ssh-select-bash.sh" \
  | sort)

if [[ ${#keys[@]} -eq 0 ]]; then
  echo "No SSH keys found in $SSH_DIR"
  return 1 2>/dev/null || exit 1
fi

echo ""
echo "Available SSH keys:"
for i in "${!keys[@]}"; do
  echo "  [$((i+1))] ${keys[$i]}"
done
echo ""

read -rp "Select key [1-${#keys[@]}]: " choice

if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#keys[@]} )); then
  echo "Invalid selection."
  return 1 2>/dev/null || exit 1
fi

selected="${keys[$((choice-1))]}"

# Start ssh-agent if not already running
if [[ -z "$SSH_AUTH_SOCK" ]]; then
  eval "$(ssh-agent -s)" > /dev/null
fi

# Clear previously loaded keys and load the selected one
ssh-add -D 2>/dev/null
ssh-add "$selected"

echo ""
echo "Active key: $selected"
