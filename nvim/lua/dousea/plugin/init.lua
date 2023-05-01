local function ensure_packer()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
    vim.cmd "packadd packer.nvim"

    return true
  end

  return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
  -- Packer can manage itself
  use "wbthomason/packer.nvim"

  use {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    requires = "nvim-lua/plenary.nvim",
    config = require("dousea.plugin.telescope"),
  }

  use {
    "rmagatti/auto-session",
    config = require("dousea.plugin.auto-session"),
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require("nvim-treesitter.install").update { with_sync = true }
      ts_update()
    end,
    config = require("dousea.plugin.treesitter"),
  }

  use "mbbill/undotree"

  use "neovim/nvim-lspconfig"

  use "mfussenegger/nvim-dap"

  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = require("dousea.plugin.null-ls"),
  }

  use {
    "williamboman/mason.nvim",
    run = ":MasonUpdate",
  }

  use "williamboman/mason-lspconfig.nvim"

  use {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    requires = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = require("dousea.plugin.lsp"),
  }

  use {
    "nvim-tree/nvim-tree.lua",
    requires = "nvim-tree/nvim-web-devicons",
    config = require("dousea.plugin.tree"),
  }

  use {
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    config = require("dousea.plugin.trouble"),
  }

  use {
    "numToStr/Comment.nvim",
    config = require("dousea.plugin.comment"),
  }

  use {
    "nvim-lualine/lualine.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    after = "auto-session",
    config = require("dousea.plugin.lualine"),
  }

  use {
    "nanozuki/tabby.nvim",
    config = require("dousea.plugin.tabby")
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    config = require("dousea.plugin.indent-blankline"),
  }

  use "tpope/vim-fugitive"

  use {
    "lewis6991/gitsigns.nvim",
    tag = "release",
    config = require("dousea.plugin.gitsigns"),
  }

  use {
    "Mofiqul/vscode.nvim",
    config = require("dousea.plugin.colors"),
  }

  use {
    "utilyre/barbecue.nvim",
    tag = "*",
    requires = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
    after = { "nvim-web-devicons", "vscode.nvim" },
    config = require("dousea.plugin.barbecue")
  }

  use {
    "folke/which-key.nvim",
    after = { "telescope.nvim", "nvim-tree.lua" },
    config = require("dousea.plugin.which-key")
  }

  -- Automatically set up our configuration after cloning packer.nvim
  if packer_bootstrap then
    require("packer").sync()
  end
end)

