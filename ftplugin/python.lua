local dap_python = require 'dap-python'

local map = function(mode, keys, func, desc)
  vim.keymap.set(mode, keys, func, { buffer = 0, silent = true, desc = 'Python: ' .. desc })
end

-- Keep test-debug mappings consistent with the Java ftplugin.
map('n', '<leader>tc', dap_python.test_class, 'Debug test [C]lass')
map('n', '<leader>tn', dap_python.test_method, 'Debug [N]earest test')
map('x', '<leader>ts', dap_python.debug_selection, 'Debug [S]election')
