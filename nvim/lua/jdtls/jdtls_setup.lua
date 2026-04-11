-- ~/.config/nvim/lua/jdtls/jdtls_setup.lua
local M = {}

function M.setup()
  local root_dir = vim.fs.root(0, { "gradlew", "mvnw", ".git" })
  if not root_dir then
    return
  end

  local project_name = vim.fn.fnamemodify(root_dir, ":t")
  local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

  -- Require a dedicated JVM for running JDTLS (must be >= 21)
  local java_home = vim.env.JAVA_JDTLS_HOME
  if not java_home or java_home == "" then
    return vim.notify("JAVA_JDTLS_HOME is not set (required to start jdtls)", vim.log.levels.ERROR)
  end

  local java_bin = java_home .. "/bin/java"
  if vim.fn.executable(java_bin) ~= 1 then
    return vim.notify("JAVA_JDTLS_HOME does not contain bin/java: " .. java_home, vim.log.levels.ERROR)
  end

  -- JDTLS install (Mason)
  local jdtls_dir = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
  if vim.fn.isdirectory(jdtls_dir) ~= 1 then
    return vim.notify("jdtls not found via Mason at: " .. jdtls_dir, vim.log.levels.ERROR)
  end

  local launcher_jar = vim.fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  if launcher_jar == "" then
    return vim.notify("jdtls launcher jar not found under: " .. jdtls_dir, vim.log.levels.ERROR)
  end

  -- Pick the correct JDTLS config dir for the current OS/arch
  local uname = vim.loop.os_uname()
  local sys = uname.sysname
  local arch = uname.machine

  local config_dir
  if sys == "Darwin" then
    config_dir = jdtls_dir .. "/config_mac"
    if vim.fn.isdirectory(jdtls_dir .. "/config_mac_arm") == 1 then
      config_dir = jdtls_dir .. "/config_mac_arm"
    end
  elseif sys == "Linux" then
    config_dir = jdtls_dir .. "/config_linux"
    if (arch:match("aarch64") or arch:match("arm")) and vim.fn.isdirectory(jdtls_dir .. "/config_linux_arm") == 1 then
      config_dir = jdtls_dir .. "/config_linux_arm"
    end
  else
    return vim.notify("Unsupported OS for jdtls: " .. sys, vim.log.levels.ERROR)
  end

  if vim.fn.isdirectory(config_dir) ~= 1 then
    return vim.notify("jdtls config dir not found: " .. config_dir, vim.log.levels.ERROR)
  end

  local config = {
    name = "jdtls",

    cmd = {
      java_bin,
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xms1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
      "-jar",
      launcher_jar,
      "-configuration",
      config_dir,
      "-data",
      workspace_dir,
    },

    root_dir = root_dir,

    settings = {
      java = {
        -- Optional: If you ever want to declare project runtimes, put them here.
        -- configuration = {
        --   runtimes = {
        --     { name = "JavaSE-17", path = "/path/to/jdk-17" },
        --   },
        -- },
      },
    },

    init_options = { bundles = {} },
  }

  require("jdtls").start_or_attach(config)
end

return M
