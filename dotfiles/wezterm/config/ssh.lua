local wezterm = require('wezterm')

local act = wezterm.action

local function split_by_whitespace(value)
   local parts = {}
   for part in string.gmatch(value, '%S+') do
      table.insert(parts, part)
   end
   return parts
end

local function read_known_hosts()
   local home = wezterm.home_dir or os.getenv('HOME') or ''
   if home == '' then
      return {}
   end

   local path = home .. '/.ssh/known_hosts'
   local file = io.open(path, 'r')
   if not file then
      return {}
   end

   local hosts = {}
   local seen = {}
   for line in file:lines() do
      if line ~= '' and not line:match('^#') then
         if not line:match('^@') and not line:match('^|1|') then
            local field = line:match('^(%S+)')
            if field and field ~= '' then
               for host in string.gmatch(field, '([^,]+)') do
                  if host ~= '' and not seen[host] then
                     seen[host] = true
                     table.insert(hosts, host)
                  end
               end
            end
         end
      end
   end
   file:close()

   table.sort(hosts)
   return hosts
end

local function format_ssh_target(host)
   if host:match('@') then
      return host
   end
   local user = os.getenv('USER') or os.getenv('USERNAME') or ''
   if user == '' then
      return host
   end
   return user .. '@' .. host
end

local function extract_ssh_title(value)
   local first_with_at = value:match('(%S+@%S+)')
   if first_with_at and first_with_at ~= '' then
      return first_with_at
   end
   local last = nil
   for part in string.gmatch(value, '%S+') do
      last = part
   end
   if last and last ~= '' then
      return last
   end
   return 'ssh'
end

local function spawn_ssh_tab(window, pane, args, title)
   window:perform_action(
      act.SpawnCommandInNewTab({ args = args }),
      pane
   )
   window:perform_action(
      act.SetTabTitle(title),
      pane
   )
end

local M = {}

M.ssh_picker_action = function()
   return wezterm.action_callback(function(window, pane)
      local choices = {}
      for _, host in ipairs(read_known_hosts()) do
         local target = format_ssh_target(host)
         table.insert(choices, { label = target, id = target })
      end
      table.insert(choices, { label = '  new ssh target', id = '__create__' })

      window:perform_action(
         act.InputSelector({
            title = 'SSH Targets',
            choices = choices,
            fuzzy = true,
            action = wezterm.action_callback(function(inner_window, inner_pane, choice_id)
               if not choice_id then
                  return
               end
               if choice_id == '__create__' then
                  inner_window:perform_action(
                     act.PromptInputLine({
                        description = 'SSH target (user@host or options)',
                        action = wezterm.action_callback(function(prompt_window, prompt_pane, line)
                           if not line or line == '' then
                              return
                           end
                           local args = { 'ssh' }
                           for _, part in ipairs(split_by_whitespace(line)) do
                              table.insert(args, part)
                           end
                           spawn_ssh_tab(prompt_window, prompt_pane, args, extract_ssh_title(line))
                        end),
                     }),
                     inner_pane
                  )
                  return
               end
               spawn_ssh_tab(inner_window, inner_pane, { 'ssh', choice_id }, choice_id)
            end),
         }),
         pane
      )
   end)
end

return M
