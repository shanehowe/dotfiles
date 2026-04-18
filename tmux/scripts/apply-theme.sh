#!/bin/bash
APPEARANCE=$(defaults read -g AppleInterfaceStyle 2>/dev/null)

if [ "$APPEARANCE" = "Dark" ]; then
  # Catppuccin Mocha
  tmux set -g status-style          "bg=#1e1e2e,fg=#a6adc8"
  tmux set -g status-left           "#[bg=#313244,fg=#cdd6f4,bold] #S "
  tmux set -g status-right          "#[bg=#313244,fg=#cba6f7]#{?client_prefix,§ ,}#[fg=#a6adc8] %H:%M "
  tmux set -g window-status-format         " #I:#W "
  tmux set -g window-status-current-format " #I:#W "
  tmux set -g window-status-style          "fg=#585b70"
  tmux set -g window-status-current-style  "fg=#89b4fa,bold"
  tmux set -g pane-border-style            "fg=#313244"
  tmux set -g pane-active-border-style     "fg=#89b4fa"
  tmux set -g message-style                "bg=#313244,fg=#cdd6f4"
else
  # Catppuccin Latte
  tmux set -g status-style          "bg=#eff1f5,fg=#6c6f85"
  tmux set -g status-left           "#[bg=#ccd0da,fg=#4c4f69,bold] #S "
  tmux set -g status-right          "#[bg=#ccd0da,fg=#8839ef]#{?client_prefix,§ ,}#[fg=#6c6f85] %H:%M "
  tmux set -g window-status-format         " #I:#W "
  tmux set -g window-status-current-format " #I:#W "
  tmux set -g window-status-style          "fg=#acb0be"
  tmux set -g window-status-current-style  "fg=#1e66f5,bold"
  tmux set -g pane-border-style            "fg=#ccd0da"
  tmux set -g pane-active-border-style     "fg=#1e66f5"
  tmux set -g message-style                "bg=#ccd0da,fg=#4c4f69"
fi
