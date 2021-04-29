local Time = {}

function Time:GetFormattedDate(osDate)
	return ("%02d/%02d/%02d %02d:%02d"):format(osDate.month, osDate.day, osDate.year, osDate.hour, osDate.min)
end

return Time
