#!/usr/bin/env bash
set -euo pipefail

# Log in only if this container isn’t already in the tailnet
if ! tailscale status &>/dev/null; then
  if [[ -n "${TS_AUTH_KEY:-}" ]]; then
    sudo tailscale up \
      --auth-key="${TS_AUTH_KEY}" \
      --accept-routes \
      --accept-dns \
      --hostname "devcontainer-$(whoami)"
  else
    echo "TS_AUTH_KEY not set – run 'sudo tailscale up' manually." >&2
  fi
fi

# Ensure the built-in resolver (Quad100) is the first entry
if ! grep -q "^nameserver 100\.100\.100\.100" /etc/resolv.conf; then
  sudo sed -i '1inameserver 100.100.100.100' /etc/resolv.conf
fi
