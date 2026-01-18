local wezterm = require("wezterm")
local act = wezterm.action

local function docker_choices()
  local ok, stdout, stderr = wezterm.run_child_process({ "bash", "-lc", "docker ps --format '{{.Names}}'" })
  if not ok then
    wezterm.log_error("docker ps failed: " .. (stderr or ""))
    return {}
  end

  local choices = {}
  for _, name in ipairs(wezterm.split_by_newlines(stdout)) do
    if name ~= "" then
      table.insert(choices, { id = name, label = name })
    end
  end
  return choices
end

local function docker_exec(window, pane)
  local choices = docker_choices()
  if #choices == 0 then
    window:toast_notification("WezTerm", "No running containers found", nil, 3000)
    return
  end

  window:perform_action(
    act.InputSelector({
      title = "docker exec -it <container> bash",
      description = "Pick a running container",
      fuzzy = true,
      choices = choices,
      action = wezterm.action_callback(function(win, p, id, _)
        if not id then
          return
        end
        win:perform_action(
          act.SpawnCommandInNewTab({
            label = "docker:" .. id,
            args = { "bash", "-lc", "source ~/.bashrc.d/docker.sh && dock " .. id .. " bash" },
          }),
          p
        )
      end),
    }),
    pane
  )
end

local default_shell = os.getenv("SHELL") or "bash"

local config = {
  enable_wayland = true,
  font_size = 13,
  term = "xterm-256color",
  use_ime = false,

  -- UI
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = false,
  window_decorations = "NONE",
  window_padding = { left = 6, right = 6, top = 6, bottom = 6 },
  color_scheme = "Gruvbox Dark (Gogh)",

  -- Cursor
  default_cursor_style = "BlinkingBlock",
  cursor_blink_rate = 500,

  -- Launchers
  default_prog = { default_shell, "-l" },
  launch_menu = {
    { label = "Login shell", args = { default_shell, "-l" } },
    { label = "Plain bash", args = { "bash" } },
    { label = "Plain zsh", args = { "zsh" } },
  },

  leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 },

  keys = {
    -- Clipboard
    { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
    { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

    -- Splits
    { key = "-", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "\\", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "H", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "L", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },
    { key = "K", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 2 }) },
    { key = "J", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 2 }) },
    { key = "w", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

    -- Tabs
    { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "r", mods = "LEADER", action = act.PromptInputLine({
      description = "Rename tab",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }) },

    -- Search/selection
    { key = "f", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }) },
    { key = "u", mods = "LEADER", action = act.QuickSelect },

    -- Docker helper
    { key = "d", mods = "LEADER", action = wezterm.action_callback(docker_exec) },

    -- Misc
    { key = "r", mods = "CTRL|SHIFT", action = act.ReloadConfiguration },
  },
}

return config
