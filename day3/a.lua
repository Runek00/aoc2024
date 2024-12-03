local U = require("utils")

local line = U.fileToString("day3/input.txt")

local out = 0
for v in string.gmatch(line, "mul%(%d+,%d+%)") do
	local nums = U.split(v, ",")
	local x = tonumber(string.sub(nums[1], 5, #nums[1]))
	local y = tonumber(string.sub(nums[2], 1, #nums[2] - 1))
	out = out + x * y
end

print("day3 part1: " .. out)

out = 0
local active = true
for i = 1, #line do
	if string.sub(line, i, i + 3) == "do()" then
		active = true
	elseif string.sub(line, i, i + 6) == "don't()" then
		active = false
	elseif active and string.sub(line, i, i + 3) == "mul(" then
		local cand = string.match(line, "mul%(%d+,%d+%)", i)
		if cand == string.sub(line, i, i + #cand - 1) then
			local nums = U.split(cand, ",")
			local x = tonumber(string.sub(nums[1], 5, #nums[1]))
			local y = tonumber(string.sub(nums[2], 1, #nums[2] - 1))
			out = out + x * y
		end
	end
end
print("day3 part2: " .. out)
