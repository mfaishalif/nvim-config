local root = vim.fn.getcwd()
package.path = root .. '/lua/?.lua;' .. root .. '/lua/?/init.lua;' .. package.path

local function reload(profile, in_container)
  package.loaded['custom.devprofile'] = nil
  vim.env.NVIM_DEV_PROFILE = profile
  vim.env.NVIM_DEVCONTAINER = in_container
  return require 'custom.devprofile'
end

local all = reload(nil, nil)
assert(all.enabled 'python')
assert(all.enabled 'node')
assert(all.enabled 'java')
assert(not all.in_devcontainer())

local python = reload('python', '1')
assert(python.enabled 'python')
assert(not python.enabled 'node')
assert(not python.enabled 'java')
assert(python.in_devcontainer())

local combined = reload('java, node', '1')
assert(combined.enabled 'java')
assert(combined.enabled 'node')
assert(not combined.enabled 'python')

local mixed = reload('python,unknown,node', '1')
assert(mixed.enabled 'python')
assert(mixed.enabled 'node')
assert(not mixed.enabled 'java')
assert(vim.deep_equal(mixed.unknown(), { 'unknown' }))

local explicit_all = reload('all', '1')
assert(explicit_all.enabled 'python')
assert(explicit_all.enabled 'node')
assert(explicit_all.enabled 'java')

print 'devprofile_spec: PASS'
