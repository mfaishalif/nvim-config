-- Generic Debug Adapter Protocol (DAP) setup.
-- Language-specific adapters are configured separately.

vim.pack.add {
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/nvim-neotest/nvim-nio',
}

local dap = require 'dap'
local dapui = require 'dapui'

dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
}

local map = function(keys, func, desc, mode)
  vim.keymap.set(mode or 'n', keys, func, { desc = 'Debug: ' .. desc })
end

map('<leader>dc', dap.continue, '[C]ontinue')
map('<leader>di', dap.step_into, 'Step [I]nto')
map('<leader>do', dap.step_over, 'Step [O]ver')
map('<leader>dO', dap.step_out, 'Step [O]ut')
map('<leader>db', dap.toggle_breakpoint, 'Toggle [B]reakpoint')
map('<leader>dB', function() dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, 'Conditional [B]reakpoint')
map('<leader>dl', dap.run_last, 'Run [L]ast')
map('<leader>dt', dap.terminate, '[T]erminate')
map('<leader>du', dapui.toggle, 'Toggle [U]I')
map('<leader>de', dapui.eval, '[E]valuate', { 'n', 'v' })

dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
