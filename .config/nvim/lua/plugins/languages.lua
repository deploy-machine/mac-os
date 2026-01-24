return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "dockerfile",
        "go",
        "gomod",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rust",
        "scss",
        "typescript",
        "tsx",
        "vim",
        "vimdoc",
        "yaml",
        "toml",
        "sql",
        "vue",
        "svelte",
        "terraform",
        "hcl",
        "graphql",
        "prisma",
        "astro",
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "lua-language-server",
        "typescript-language-server",
        "eslint-lsp",
        "json-lsp",
        "html-lsp",
        "css-lsp",
        "docker-compose-language-service",
        "docker-language-server",
        "dockerfile-language-server",
        "gh-actions-language-server",
        "python-lsp-server",
        "gopls",
        "rust-analyzer",
        
        -- Formatters
        "prettier",
        "shfmt",
        "stylua",
        "htmlbeautifier",
        
        -- Linters
        "snyk",
        
        -- Tools
        "jq",
        "tree-sitter-cli",
        "gh",
        
        -- Additional language tools
        "wasm-language-tools",
        
        -- opencode support
        "opencode",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {},
        tsserver = {},
        eslint = {},
        jsonls = {},
        html = {},
        cssls = {},
        dockerls = {},
        docker_compose_language_service = {},
        pylsp = {},
        gopls = {},
        rust_analyzer = {},
      },
    },
  },
}