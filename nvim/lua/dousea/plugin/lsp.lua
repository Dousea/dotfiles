return function()
  local lsp = require("lsp-zero").preset {}

  lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps { buffer = bufnr }

    if client.server_capabilities.documentSymbolProvider then
      require('nvim-navic').attach(client, bufnr)
    end
  end)

  -- Ensure to install these language servers (NOT formatters and linters)
  lsp.ensure_installed {
    "lua_ls",
    "tsserver",
    "solargraph",
  }

  lsp.set_sign_icons {
    hint = "",
    info = "",
    warn = "",
    error = "",
  }

  lsp.setup()

  local cmp = require("cmp")

  cmp.setup {
    mapping = {
      ["<S-Tab>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
      ["<Tab>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
      ["<CR>"] = cmp.mapping.confirm { select = false },
      ["<C-Space>"] = cmp.mapping.complete(),
    },
    preselect = "item",
    completion = {
      completeopt = "menu,menuone,noinsert"
    },
  }
end
