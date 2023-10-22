local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Check packer is installed
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  vim.notify("packer.vim is not installed")
  return
end

-- Packer info as popup window
packer.init {
  display = {
    open_fn = require("packer.util").float
  },
}

-- Plugins to install
return packer.startup(function(use)
  use "wbthomason/packer.nvim" -- Have packer manage itself

  -- Colorscheme
  use {
    "Mofiqul/vscode.nvim",
    config = function()
      require("config.colorscheme").setup()
    end
  }

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    requires = { {"nvim-lua/plenary.nvim"} }
  }

  -- Snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- snippets for bunch of language

  -- LSP
  use {
    "neovim/nvim-lspconfig",
    config = function()
      require("config.lsp").setup()
    end,
    requires = { "hrsh7th/cmp-nvim-lsp" }
  }

  use {
    "williamboman/mason.nvim", -- simple to use language server installer
    run = ":MasonUpdate", -- :MasonUpdate updates registry contents
    config = function()
      require("config.lsp-mason").setup()
    end,
    requires = {
      "williamboman/mason-lspconfig.nvim" -- simple to use language server installer
    }
  }

  -- Completion
  use {
    "hrsh7th/nvim-cmp",
    config = function()
      require("config.completion").setup()
    end,
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip"
    }
  }

  -- Keymaps
  use {
    "mrjones2014/legendary.nvim",
    config = function()
      require("config.keymaps").setup()
    end,
    requires = { "stevearc/dressing.nvim" }
  }

  -- Autopairs
  use {
	  "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end
  }

  -- Explorer
  use {
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({})
    end
  }

  -- Statusline
  use {
	  "jssteinberg/hackline.vim",
  	requires = { "itchyny/vim-gitbranch" },
  }

  -- Syntax Highlighting
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "html",
          "javascript",
          "jsdoc",
          "json",
          "lua",
          "markdown",
          "php",
          "phpdoc",
          "python",
          "regex",
          "sql",
          "yaml",
        },
        highlight = {
          enable = true
        }
      })
    end
  }

  use {
    "rcarriga/nvim-dap-ui"
    ,
    requires = {
      { "mfussenegger/nvim-dap" },
      { "mxsdev/nvim-dap-vscode-js" },
      {
        "microsoft/vscode-js-debug",
        opt = true,
        run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
      }
    },
    config = function()
      require("dap-vscode-js").setup({
        adapters = {
          'pwa-node',
          'pwa-chrome',
          'pwa-msedge',
          'node-terminal',
          'pwa-extensionHost'
        },
      })

      for _, language in ipairs({ "typescript", "javascript" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require'dap.utils'.pick_process,
            cwd = "${workspaceFolder}",
          }
        }
      end

      require("dapui").setup()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  }

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
