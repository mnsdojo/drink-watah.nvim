-- lua/drink-watah/utils.lua
--
local M = {}

function M.validate_interval(interval)
	interval = tonumber(interval)
	if not interval or interval < 1 then
		error("interval must be pawsitive number")
	end
	return interval
end

-- suppress if quiet hours

function M.is_quiet_hours()
	local config = require("drink-watah.config")
	if not config.options.quiet_hours.enabled then
		return false
	end
	local current_hour = tonumber(os.date("%H"))
	local start_hour = config.options.quiet_hours.start
	local end_hour = config.options.quiet_hours.start
	if start_hour <= end_hour then
		return current_hour >= start_hour or current_hour < end_hour
	else
		return current_hour >= start_hour or current_hour < end_hour
	end
end

function M.show_notification(msg, level)
	if not M.is_quiet_hours() then
		vim.notify(msg, level or vim.log.levels.INFO, {
			title = require("drink-watah.config").options.notification_title,
			timeout = require("drink-watah.config").options.notification_duration,
		})
	end
end
function M.format_time(minutes)
	if minutes < 60 then
		return string.format("%d minutes", minutes)
	else
		local hours = math.floor(minutes / 60)
		local mins = minutes % 60
		return string.format(
			"%d hour%s%s%s",
			hours,
			hours > 1 and "s" or "",
			mins > 0 and " and " or "",
			mins > 0 and string.format("%d minutes", mins) or ""
		)
	end
end

return M
