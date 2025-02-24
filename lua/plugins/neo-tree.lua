return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			filesystem = {
				window = {
					mappings = {
						["<leader>p"] = "image_wezterm", -- " or another map
					},
				},
				commands = {
					image_wezterm = function(state)
						local node = state.tree:get_node()
						if node.type == "file" then
							require("image_preview").PreviewImage(node.path)
						end
					end,
				},
				filtered_items = {
					visible = true, -- when true, they will just be displayed differently than normal items
					hide_dotfiles = true,
					hide_hidden = true,
					hide_gitignored = true,
					always_show = { -- remains visible even if other settings would normally hide it
						".vscode",
						".jenkinsfiles",
					},
					never_show = {
						".git",
						".github",
					},
				},
			},
		})
	end,
	vim.keymap.set("n", "<C-e>", "<Cmd>Neotree toggle<CR>"),
}
