local U = require("utils")
local Q = require("queue")

local ints = U.mapXD(U.tableTo2DCharArray(U.fileToTable("day10/input.txt")), 2, tonumber)

local starts = {}

for i = 1, #ints do
	for j = 1, #ints[i] do
		if ints[i][j] == 0 then
			table.insert(starts, { a = i, b = j })
		end
	end
end

local trailcounter = 0

local function findNines(point)
	local found = {}
	local queue = Q.createQueue()
	Q.enqueue(queue, point)
	while not Q.isEmpty(queue) do
		local pt = Q.dequeue(queue)
		if ints[pt.a][pt.b] == 9 then
			found[U.pstr(pt)] = true
			trailcounter = trailcounter + 1
		else
			for _, dir in ipairs(U.getAllDirections()) do
				local newPoint = { a = pt.a + dir.a, b = pt.b + dir.b }
				if U.pointInBounds(newPoint, ints) and ints[newPoint.a][newPoint.b] == ints[pt.a][pt.b] + 1 then
					Q.enqueue(queue, newPoint)
				end
			end
		end
	end
	local counter = 0
	for _, _ in pairs(found) do
		counter = counter + 1
	end
	return counter
end

local sum = 0
for i = 1, #starts do
	sum = sum + findNines(starts[i])
end
print("Day 10, part 1: " .. sum)

print("Day 10, part 2: " .. trailcounter)
