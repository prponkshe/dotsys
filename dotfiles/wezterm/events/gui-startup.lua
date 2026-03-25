local wezterm = require('wezterm')
local mux = wezterm.mux

local M = {}

M.setup = function()
   wezterm.on('gui-startup', function(cmd)
      local default_workspaces = {
         { name = 'default' },
         { name = 'zippy', cwd = wezterm.home_dir .. '/git/zippy/zippy' },
         { name = 'veloce', cwd = wezterm.home_dir .. '/git/veloce/just-core' },
      }

      for idx, entry in ipairs(default_workspaces) do
         local spawn = { workspace = entry.name, cwd = entry.cwd }
         if idx == 1 and cmd and cmd.args then
            spawn.args = cmd.args
         end
         local _, _, window = mux.spawn_window(spawn)
         if idx == 1 then
            window:gui_window():maximize()
            mux.set_active_workspace(entry.name)
         end
      end
   end)
end

return M
