local U = require("utils")
local Q = require("queue")

local function toPoints(line)
	local ba = U.split(line, ",")
	return U.point(tonumber(ba[2]) + 1, tonumber(ba[1]) + 1)
end

local walls = U.map(U.fileToTable("day18/input.txt"), toPoints)

local mapSize = 71
local firstBytes = 1024

local map = {}
for i = 1, mapSize do
	map[i] = {}
	for j = 1, mapSize do
		map[i][j] = "."
	end
end

for i = 1, firstBytes do
	local wall = walls[i]
	map[wall.a][wall.b] = "#"
end

local distances = {}
local minDist = math.huge
local queue = Q.createQueue()
local start = U.point(1, 1)
Q.enqueue(queue, { s = start, steps = 0 })

local function findEnd(point, distSoFar)
	if not U.pointInBounds(point, map) then
		return
	end
	if map[point.a][point.b] == "#" then
		return
	end

	if distSoFar > minDist then
		return
	end

	if point.a == mapSize and point.b == mapSize then
		if distSoFar < minDist then
			distances[U.pstr(point)] = distSoFar
			minDist = distSoFar
		end
		return
	end

	if distances[U.pstr(point)] ~= nil and distances[U.pstr(point)] <= distSoFar then
		return
	end

	if map[point.a][point.b] == "." then
		distances[U.pstr(point)] = distSoFar
	end

	for _, dir in ipairs(U.getAllDirections()) do
		local sideStep = U.addPoints(point, dir)
		Q.enqueue(queue, { s = sideStep, steps = distSoFar + 1 })
	end
end

while not Q.isEmpty(queue) do
	local stepAndDist = Q.dequeue(queue)
	findEnd(stepAndDist.s, stepAndDist.steps)
end

print("Day 18 part 1: " .. minDist)

local result
for i = firstBytes + 1, #walls do
	local wall = walls[i]
	map[wall.a][wall.b] = "#"

	distances = {}
	minDist = math.huge
	queue = Q.createQueue()
	Q.enqueue(queue, { s = start, steps = 0 })
	while not Q.isEmpty(queue) do
		local stepAndDist = Q.dequeue(queue)
		findEnd(stepAndDist.s, stepAndDist.steps)
	end
	if minDist == math.huge then
		result = wall
		break
	end
end

print("Day 18 part 2: " .. result.b - 1 .. "," .. result.a - 1)
