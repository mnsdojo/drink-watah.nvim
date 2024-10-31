local M = {}

local config = require("drink-watah.config")
local utils = require("drink-watah.utils")

local timer = nil

local function show_reminder()
	utils.show_notification(config.options.notification_message)
end

return M
