local U = require("utils")

local results = {}

local function blink(stone, count)
	if count == 0 then
		return 1
	end
	local result
	if results[stone .. "|" .. count] ~= nil then
		return results[stone .. "|" .. count]
	end
	if #("" .. stone) % 2 == 0 then
		local s1 = tonumber(("" .. stone):sub(1, #("" .. stone) / 2))
		local s2 = tonumber(("" .. stone):sub(#("" .. stone) / 2 + 1))
		result = blink(s1, count - 1) + blink(s2, count - 1)
		return result
	elseif stone == 0 then
		result = blink(1, count - 1)
	else
		result = blink(stone * 2024, count - 1)
	end
	results[stone .. "|" .. count] = result
	return result
end

local stones = U.tabToNum(U.split(U.fileToString("day11/input.txt"), " "))

local out = 0
for _, stone in ipairs(stones) do
	out = out + blink(stone, 25)
end

print("day 11 part 1: " .. string.format("%20.0f", out))

out = 0
for _, stone in ipairs(stones) do
	out = out + blink(stone, 75)
end

print("day 11 part 2: " .. string.format("%20.0f", out))
