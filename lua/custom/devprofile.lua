local M = {}

local known = {
  python = true,
  node = true,
  java = true,
}

local selected = {}
local unknown = {}
local raw = vim.env.NVIM_DEV_PROFILE

if raw == nil or vim.trim(raw) == '' then
  selected.all = true
else
  for part in raw:gmatch '[^,]+' do
    local name = vim.trim(part):lower()
    if name == 'all' then
      selected.all = true
    elseif known[name] then
      selected[name] = true
    elseif name ~= '' then
      table.insert(unknown, name)
    end
  end
end

function M.enabled(name) return selected.all == true or selected[name] == true end

function M.in_devcontainer() return vim.env.NVIM_DEVCONTAINER == '1' end

function M.selected() return vim.deepcopy(selected) end

function M.unknown() return vim.deepcopy(unknown) end

return M
