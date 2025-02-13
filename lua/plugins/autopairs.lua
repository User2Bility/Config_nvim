return {
	"windwp/nvim-autopairs",
	lazy = false,
	config = function()
		require("nvim-autopairs").setup({
			check_ts = true,
			fast_wrap = {},
		})
	end,
}
