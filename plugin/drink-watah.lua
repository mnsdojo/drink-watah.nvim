-- Checking if plugin is loaded
if vim.g.loaded_drink_watah == 1 then
	return
end
vim.g.loaded_drink_watah = 1

-- Create autocommand group
local group = vim.api.nvim_create_augroup("DrinkWatah", { clear = true })

-- Stop plugin on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
	group = group,
	callback = function()
		require("drink-watah").stop()
	end,
})

-- Simple setup command
vim.api.nvim_create_user_command("DWSetup", function()
	require("drink-watah").setup()
end, {})
