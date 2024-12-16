local U = require("utils")
local Q = require("queue")

local map = U.tableTo2DCharArray(U.fileToTable("day16/input.txt"))

local start
local finish

for i = 1, #map do
	for j = 1, #map[i] do
		if map[i][j] == "S" then
			start = U.step(i, j, U.E)
		end
		if map[i][j] == "E" then
			finish = { a = i, b = j }
		end
	end
end

local distances = {}
local minDist = math.huge
local queue = Q.createQueue()
Q.enqueue(queue, { s = start, steps = 0 })

local function findEnd(step, distSoFar)
	if map[step.a][step.b] == "#" then
		return
	end

	if distSoFar > minDist then
		return
	end

	if map[step.a][step.b] == "E" then
		if distSoFar < minDist then
			distances[U.str(step)] = distSoFar
			minDist = distSoFar
		end
		return
	end

	if distances[U.str(step)] ~= nil and distances[U.str(step)] <= distSoFar then
		return
	end

	for _, dir in ipairs(U.getAllDirections()) do
		local sideStep = U.step(step.a, step.b, dir)
		if distances[U.str(sideStep)] ~= nil and distances[U.str(sideStep)] + 1000 < distSoFar then
			distances[U.str(step)] = 1000 + distances[U.str(sideStep)]
			return
		end
	end

	if distances[U.str(step)] == nil or distances[U.str(step)] > distSoFar then
		distances[U.str(step)] = distSoFar
	end

	for _, dir in ipairs(U.getAllDirections()) do
		if U.pstr(dir) ~= U.pstr(step.to) and U.pstr(dir) ~= U.pstr(U.opposite(step.to)) then
			local turned = U.step(step.a, step.b, dir)
			Q.enqueue(queue, { s = turned, steps = distSoFar + 1000 })
		end

		if U.pstr(dir) == U.pstr(step.to) then
			local forward = U.forward(step)
			Q.enqueue(queue, { s = forward, steps = distSoFar + 1 })
		end
	end
end

while not Q.isEmpty(queue) do
	local stepAndDist = Q.dequeue(queue)
	findEnd(stepAndDist.s, stepAndDist.steps)
end

print("Day 16 part 1: ", minDist)

queue = Q.createQueue()

for _, dir in ipairs(U.getAllDirections()) do
	local step = U.step(finish.a, finish.b, dir)
	distances[U.str(step)] = minDist
	Q.enqueue(queue, step)
end

local function findPath(step)
	for _, dir in ipairs(U.getAllDirections()) do
		if U.pstr(dir) ~= U.pstr(step.to) and U.pstr(dir) ~= U.pstr(U.opposite(step.to)) then
			local turned = U.step(step.a, step.b, dir)
			if distances[U.str(turned)] == distances[U.str(step)] - 1000 then
				Q.enqueue(queue, turned)
			end
		end
		if U.pstr(dir) == U.pstr(U.opposite(step.to)) then
			local forward = U.stepFromPoint(U.addPoints(step, dir), step.to)
			if map[forward.a][forward.b] == "." then
				if distances[U.str(forward)] == distances[U.str(step)] - 1 then
					map[forward.a][forward.b] = "O"
					Q.enqueue(queue, forward)
				end
			end
		end
	end
end

while not Q.isEmpty(queue) do
	local step = Q.dequeue(queue)
	findPath(step)
end

local result = 0
for i = 1, #map do
	for j = 1, #map[i] do
		if map[i][j] == "O" or map[i][j] == "S" or map[i][j] == "E" then
			result = result + 1
		end
	end
end

print("Day 16 part 2: ", result)
