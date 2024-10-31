local M = {}

local config = require("drink-watah.config")
local utils = require("drink-watah.utils")

local timer = nil

local function show_reminder()
	utils.show_notification(config.options.notification_message)
end

local function start_timer()
	if timer then
		timer:stop()
		timer:close() -- Properly close the timer to prevent memory leaks
	end

	timer = vim.uv.new_timer()
	if not timer then
		vim.notify("Failed to create timer", vim.log.levels.ERROR)
		return
	end

	local interval = config.options.reminder_interval * 60 * 1000
	local ok, err = pcall(function()
		timer:start(
			0, -- First timeout (immediate)
			interval, -- Repeat interval in milliseconds
			vim.schedule_wrap(function()
				if config.options.enabled then
					show_reminder()
				end
			end)
		)
	end)

	if not ok then
		vim.notify("Failed to start timer: " .. tostring(err), vim.log.levels.ERROR)
		timer:close()
		timer = nil
	end
end

function M.stop()
	if timer then
		timer:stop()
		timer:close()
		timer = nil
	end
end

local function create_commands()
	-- Toggle reminder
	vim.api.nvim_create_user_command("DWToggle", function()
		config.options.enabled = not config.options.enabled
		utils.show_notification("Hydrrate is now " .. (config.options.enabled and "enabled" or "disabled"))
	end, {})

	-- Show status
	vim.api.nvim_create_user_command("DWStatus", function()
		local status_message = string.format(
			"Status: %s\nReminder Interval: %s",
			config.options.enabled and "✅ Active" or "⏸️  Paused",
			utils.format_time(config.options.reminder_interval)
		)
		utils.show_notification(status_message)
	end, {})
	-- Set interval
	vim.api.nvim_create_user_command("DWSetInt", function(opts)
		local new_interval = utils.validate_interval(opts.args)
		config.options.reminder_interval = new_interval
		start_timer() -- Restart timer with new interval
		utils.show_notification(string.format("Reminder interval set to %s", utils.format_time(new_interval)))
	end, {
		nargs = 1,
		desc = "Set hydration reminder interval in minutes",
	})
end

function M.setup(opts)
	config.setup(opts)
	create_commands()
	start_timer()
end

return M
