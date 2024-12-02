local U = require("utils")

local inn = U.fileToTable("day1/input.txt")

local l1 = {}
local l2 = {}
for _, v in ipairs(inn) do
	local t = U.split(v, "   ")
	table.insert(l1, tonumber(t[1]))
	table.insert(l2, tonumber(t[2]))
end

table.sort(l1)
table.sort(l2)

local out = 0
for i = 1, #l1 do
	out = out + math.abs(l1[i] - l2[i])
end

print("day 1 part 1: ", out)

l1 = {}
l2 = {}
for _, v in ipairs(inn) do
	local t = U.split(v, "   ")

	table.insert(l1, tonumber(t[1]))

	local num = tonumber(t[2])
	if l2[num] == nil then
		l2[num] = 1
	else
		l2[num] = l2[num] + 1
	end
end

out = 0

for _, v in ipairs(l1) do
	local cnt = l2[v]
	if cnt == nil then
		cnt = 0
	end
	out = out + cnt * v
end

print("day 1 part 2: ", out)
