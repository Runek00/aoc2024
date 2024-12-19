local U = require("utils")

local lines = U.fileToTable("day19/input.txt")

local patternList = U.split(lines[1], ", ")
local patterns = {}

local lengths = {}

for _, pattern in ipairs(patternList) do
	patterns[pattern] = true
	lengths[#pattern] = true
end

local foundDesigns = {}

local function findPattern(design)
	if foundDesigns[design] then
		return foundDesigns[design]
	end

	local found = 0

	if patterns[design] then
		found = found + 1
	end

	for length, _ in pairs(lengths) do
		if length < #design then
			local newDesign = string.sub(design, 1, length)
			if patterns[newDesign] then
				found = found + findPattern(string.sub(design, length + 1))
			end
		end
	end
	foundDesigns[design] = found
	return found
end

local result = 0
for i = 3, #lines do
	local design = lines[i]
	if findPattern(design) > 0 then
		result = result + 1
	end
end

print("Day 19 part 1: " .. result)

result = 0
for i = 3, #lines do
	local design = lines[i]
	result = result + findPattern(design)
end

print("Day 19 part 2: " .. string.format("%20.0f", result))
