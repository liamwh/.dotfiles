#!/bin/zsh

latest_session=$(zellij ls --reverse --short | head -n 1)
if [[ -n "$latest_session" ]]; then
  echo "Attaching to session: $latest_session"
  exec zellij attach "$latest_session"
else
    zellij attach --create --index 0
fi