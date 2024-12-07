local U = require("utils")

local lines = U.fileToTable("day7/input.txt")

local cases = {}

for i, line in ipairs(lines) do
	local spl = U.split(line, ": ")
	cases[i] = {}
	cases[i].result = tonumber(spl[1])
	cases[i].nums = U.tabToNum(U.split(spl[2], " "))
end

local resultSum = 0

local function checkEquation(result, nums, idx)
	if idx == 1 then
		return result == nums[idx]
	end
	local out = false
	if result % nums[idx] == 0 then
		out = out or checkEquation(result / nums[idx], nums, idx - 1)
	end
	out = out or checkEquation(result - nums[idx], nums, idx - 1)
	return out
end

for _, case in ipairs(cases) do
	if checkEquation(case.result, case.nums, #case.nums) then
		resultSum = resultSum + case.result
	end
end

print("day 7 part 1: " .. resultSum)

resultSum = 0
local function checkEquation2(result, nums, idx)
	if idx == 1 then
		return result == nums[idx]
	end
	if idx < 1 then
		return false
	end
	if result % nums[idx] == 0 then
		if checkEquation2(result / nums[idx], nums, idx - 1) then
			return true
		end
	end
	if checkEquation2(result - nums[idx], nums, idx - 1) then
		return true
	end
	local numSize = 10 ^ #("" .. nums[idx])
	if (result - nums[idx]) % numSize == 0 then
		if checkEquation2((result - nums[idx]) / numSize, nums, idx - 1) then
			return true
		end
	end
	return false
end

for _, case in ipairs(cases) do
	if checkEquation2(case.result, case.nums, #case.nums) then
		resultSum = resultSum + case.result
	end
end

print("day 7 part 2: " .. string.format("%20.0f", resultSum))
