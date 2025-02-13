return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			-- Базовая настройка Lua LS
			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
							path = vim.split(package.path, ";"),
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			-- Настройка Go LS
			lspconfig.gopls.setup({
				cmd = { "gopls" },
				filetypes = { "go", "gomod" },
				root_dir = lspconfig.util.root_pattern("go.mod"),
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
							shadow = true,
						},
						staticcheck = true,
						experimentalPostfixCompletions = true,
					},
				},
			})

			-- Настройка CSS LS серверов
			local css_config = {
				capabilities = require("cmp_nvim_lsp").default_capabilities(
					vim.lsp.protocol.make_client_capabilities()
				),
				flags = {
					debounce_text_changes = 150,
				},
				settings = {
					css = {
						validate = true,
						lint = {
							unknownProperties = "ignore",
							invalidFunctions = "warn",
						},
						completion = {
							completePropertyWithSemicolon = true,
							completeCustomProperties = true,
						},
					},
				},
			}

			-- CSS Language Server
			lspconfig.cssls.setup(css_config)

			-- CSS Modules LS
			lspconfig.cssmodules_ls.setup({
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				root_dir = lspconfig.util.root_pattern("package.json"),
			})

			-- Inocss LS
			lspconfig.inocss.setup(css_config)

			-- CSS Variables LS
			lspconfig.css_variables.setup(css_config)

			-- Настройка автодополнения и клавиатурных сокращений
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local opts = { buffer = ev.buf }

					-- Базовые LSP карты
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename Symbol" })
					vim.keymap.set({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<Leader>lf", function()
						vim.lsp.buf.format({ async = true })
					end, opts)

					-- Дополнительные карты для CSS
					vim.keymap.set("n", "<Leader>cs", vim.lsp.buf.document_symbol, opts)
					vim.keymap.set("n", "<Leader>cl", function()
						vim.diagnostic.open_float()
					end, opts)
				end,
			})
		end,
	},
}
