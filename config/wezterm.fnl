(local wezterm (require :wezterm))

(local config (if wezterm.config_builder (wezterm.config_builder) {}))

(macro set-config [n v]
  `(tset config ,(tostring n) ,v))

(set-config font (wezterm.font "Fira Code"))
(set-config color_scheme "Catppuccin Frappe")
; apparent bug in nix build
(set-config front_end :WebGpu)

config
