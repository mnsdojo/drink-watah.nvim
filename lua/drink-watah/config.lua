local M = {}
M.defaults = {
	reminder_interval = 30, -- minutes
	notification_duration = 5000, -- milliseconds
	enabled = true,
	notification_message = "🚰 Yo! Time to drrink sum watah!",
	notification_title = "Drrink Watah!",
	quiet_hours = {
		enabled = false,
		start = 23, -- 11 PM
		finish = 7, -- 7 AM
	},
}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
