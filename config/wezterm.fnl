(local wezterm (require :wezterm))

(local config (if wezterm.config_builder (wezter.config_builder) {}))

(fn set-config [n v]
  (tset config n v))

(set-config :font (wezterm.font "Fira Code"))

config