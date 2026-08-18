local jdtls = require 'jdtls'

-- Prefer project-level markers for Maven/Gradle workspaces.
-- Fall back to a single-module build file, then the current working directory.
local root_dir = vim.fs.root(0, {
  'mvnw',
  'gradlew',
  'settings.gradle',
  'settings.gradle.kts',
  '.git',
}) or vim.fs.root(0, {
  'pom.xml',
  'build.gradle',
  'build.gradle.kts',
}) or vim.fn.getcwd()

local project_name = vim.fs.basename(root_dir)
local workspace_dir = vim.fn.stdpath 'cache' .. '/jdtls/workspace/' .. project_name

-- Mason v2 exposes stable non-executable package files through $MASON/share.
local mason_root = vim.env.MASON or (vim.fn.stdpath 'data' .. '/mason')
local mason_share = mason_root .. '/share'
local bundles = {}

local java_debug_bundle = mason_share .. '/java-debug-adapter/com.microsoft.java.debug.plugin.jar'
if vim.uv.fs_stat(java_debug_bundle) then
  table.insert(bundles, java_debug_bundle)
end

local java_test_dir = mason_share .. '/java-test'
if vim.uv.fs_stat(java_test_dir) then
  local excluded = {
    ['com.microsoft.java.test.runner-jar-with-dependencies.jar'] = true,
    ['jacocoagent.jar'] = true,
  }

  for _, bundle in ipairs(vim.fn.globpath(java_test_dir, '*.jar', true, true)) do
    if not excluded[vim.fs.basename(bundle)] then
      table.insert(bundles, bundle)
    end
  end
end

local config = {
  name = 'jdtls',
  cmd = { 'jdtls', '-data', workspace_dir },
  root_dir = root_dir,
  settings = {
    java = {},
  },
  init_options = {
    bundles = bundles,
  },
}

jdtls.start_or_attach(config)

local map = function(mode, keys, func, desc)
  vim.keymap.set(mode, keys, func, { buffer = 0, silent = true, desc = 'Java: ' .. desc })
end

map('n', '<leader>jo', jdtls.organize_imports, '[O]rganize imports')
map('n', '<leader>jv', jdtls.extract_variable, 'Extract [V]ariable')
map('x', '<leader>jv', function() jdtls.extract_variable(true) end, 'Extract [V]ariable')
map('n', '<leader>jc', jdtls.extract_constant, 'Extract [C]onstant')
map('x', '<leader>jc', function() jdtls.extract_constant(true) end, 'Extract [C]onstant')
map('x', '<leader>jm', function() jdtls.extract_method(true) end, 'Extract [M]ethod')
map('n', '<leader>tc', jdtls.test_class, 'Test [C]lass')
map('n', '<leader>tn', jdtls.test_nearest_method, 'Test [N]earest method')
