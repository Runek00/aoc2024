local U = require("utils")

local line = U.tabToNum(U.tableTo2DCharArray(U.fileToTable("day9/input.txt"))[1])
local l2 = {}

for i, v in ipairs(line) do
	local val = math.floor(i / 2)
	if i % 2 == 0 then
		val = -1
	end
	for _ = 1, v do
		table.insert(l2, val)
	end
end

local rid = #l2

local function checkRid()
	if l2[rid] == -1 then
		l2[rid] = nil
		rid = rid - 1
		checkRid()
	end
end

for lid = 1, #l2 do
	if l2[lid] == nil then
		break
	end
	if l2[lid] == -1 then
		l2[lid] = l2[rid]
		l2[rid] = nil
		rid = rid - 1
		checkRid()
	end
end

local result = 0
for i, v in ipairs(l2) do
	result = result + v * (i - 1)
	s = i
end

print("day 9 part 1: " .. result)
