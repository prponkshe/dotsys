-- -- ============================================================================
-- -- BUFFERS
-- -- ============================================================================
-- Always show tabline
vim.opt.showtabline = 2

-- Bufferline-like custom tabline
vim.opt.tabline = "%!v:lua.BufferLine()"

function _G.BufferLine()
  local s = ""
  local current = vim.fn.bufnr('%')

  for _, bufnr in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
    local b = bufnr.bufnr
    local name = vim.fn.fnamemodify(bufnr.name ~= "" and bufnr.name or "[No Name]", ":t")
    local modified = vim.fn.getbufvar(b, "&modified") == 1 and " [+]" or ""

    -- Highlight active buffer
    if b == current then
      s = s .. "%#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end

    -- Clickable tab segments (for GUI & some terminals)
    s = s .. "%" .. b .. "@" .. "v:lua.BufferLineClick" .. "@" -- buffer click handler
    s = s .. " " .. name .. modified .. " "
    s = s .. "%X" -- end clickable
  end

  s = s .. "%#TabLineFill#"
  return s
end

-- Optional: Click support (used above)
function _G.BufferLineClick(minwid, _, _, _)
  vim.cmd("buffer " .. minwid)
end

-- Transparent background like your original
vim.cmd([[
  hi TabLineFill guibg=NONE ctermfg=242 ctermbg=NONE
  hi TabLine guibg=NONE guifg=#888888
  hi TabLineSel guibg=NONE guifg=#ffffff gui=bold
]])

