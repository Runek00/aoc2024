local U = require("utils")
local Q = require("queue")

local distances = {}
local minDist = math.huge
local queue = Q.createQueue()

local map = U.tableTo2DCharArray(U.fileToTable("day20/input.txt"))
local start

for i = 1, #map do
	for j = 1, #map do
		if map[i][j] == "S" then
			start = U.point(i, j)
			break
		end
	end
end

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

	if map[point.a][point.b] == "E" then
		if distSoFar < minDist then
			distances[U.pstr(point)] = distSoFar
			minDist = distSoFar
		end
		return
	end

	if distances[U.pstr(point)] ~= nil and distances[U.pstr(point)] <= distSoFar then
		return
	end

	if map[point.a][point.b] == "." or map[point.a][point.b] == "S" then
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

for i = 1, #map do
	for j = 1, #map[i] do
		if map[i][j] == "." then
			map[i][j] = distances[i .. "|" ..j]
		end
	end
end

--U.printMap(map)


local result = 0

local function rightFrom(dir)
	if dir == U.N then 
		return U.E
	elseif dir == U.E then
		return U.S
	elseif dir == U.S then
		return U.W
	else return U.N
	end
end

local c = 100

for i = 1, #map do
	for j = 1, #map[i] do
		local p1 = U.point(i,j)
		for _, dir in ipairs(U.getAllDirections()) do
			local p2 = U.addPoints(U.addPoints(p1, dir), dir)
			if U.pointInBounds(p2, map) and distances[U.pstr(p1)] ~= nil and distances[U.pstr(p2)] ~= nil then
				if distances[U.pstr(p1)] + c + 2 <= distances[U.pstr(p2)] then
					--print(U.pstr(p1) .. " " .. U.pstr(p2) .. " " .. distances[U.pstr(p2)] - distances[U.pstr(p1)])
					result = result + 1
				end
			end
			local dir2 = rightFrom(dir)
			p2 = U.addPoints(U.addPoints(p1, dir), dir2)
			if U.pointInBounds(p2, map) and distances[U.pstr(p1)] ~= nil and distances[U.pstr(p2)] ~= nil then
				if distances[U.pstr(p1)] + c + 2 <= distances[U.pstr(p2)] then
					--print(U.pstr(p1) .. " " .. U.pstr(p2) .. " " .. distances[U.pstr(p2)] - distances[U.pstr(p1)])
					result = result + 1
				end
			end
		end
	end
end

print(result)

