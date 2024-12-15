local U = require("utils")

local mapins = U.fileToTable("day15/input.txt")

local map = {}
local i = 1

repeat
	local line = mapins[i]
	map[i] = {}
	for j = 1, #line do
		map[i][j] = line:sub(j, j)
	end
	i = i + 1
until line == "" or line == nil

local ins = ""
for j = i, #mapins do
	ins = ins .. mapins[j]
end

local function printMap()
	for i = 1, #map do
		local l = ""
		for j = 1, #map[i] do
			l = l .. map[i][j]
		end
		print(l)
	end
end

local function move(point, dir)
	if map[point.a][point.b] == "#" then
		return false
	end
	if map[point.a][point.b] == "." then
		return true
	end
	local there = U.addPoints(point, dir)
	if move(there, dir) then
		map[there.a][there.b] = map[point.a][point.b]
		map[point.a][point.b] = "."
		return true
	end
	return false
end

local start = {}
for i = 1, #map do
	for j = 1, #map[i] do
		if map[i][j] == "@" then
			start = { a = i, b = j }
		end
	end
end

local dirs = {}
dirs["^"] = U.N
dirs["v"] = U.S
dirs["<"] = U.W
dirs[">"] = U.E

local p = start
for i = 1, #ins do
	local dir = dirs[ins:sub(i, i)]
	if move(p, dir) then
		p = U.addPoints(p, dir)
	end
end

local function gps(sym)
	local out = 0
	for i = 1, #map do
		for j = 1, #map[i] do
			if map[i][j] == sym then
				out = out + 100 * (i - 1) + j - 1
			end
		end
	end
	return out
end

local function gps1()
	return gps("O")
end

print("Day 15 part 1: " .. gps1())

local function widen(map)
	local out = {}
	for i = 1, #map do
		out[i] = {}
		for j = 1, #map[i] do
			if map[i][j] == "O" then
				table.insert(out[i], "[")
				table.insert(out[i], "]")
			elseif map[i][j] == "@" then
				table.insert(out[i], "@")
				table.insert(out[i], ".")
			else
				table.insert(out[i], map[i][j])
				table.insert(out[i], map[i][j])
			end
		end
	end
	return out
end

local function canMove(point, dir, isSide)
	if map[point.a][point.b] == "#" then
		return false
	end
	if map[point.a][point.b] == "." then
		return true
	end
	local there = U.addPoints(point, dir)
	if (dir == U.N or dir == U.S) and map[point.a][point.b] ~= "@" and not isSide then
		local side
		if map[point.a][point.b] == "[" then
			side = { a = point.a, b = point.b + 1 }
		elseif map[point.a][point.b] == "]" then
			side = { a = point.a, b = point.b - 1 }
		end
		return canMove(there, dir, false) and canMove(side, dir, true)
	else
		return canMove(there, dir, false)
	end
end

local function doMove(point, dir, isSide)
	if map[point.a][point.b] == "." then
		return
	end
	if (dir == U.N or dir == U.S) and map[point.a][point.b] ~= "@" and not isSide then
		local side
		if map[point.a][point.b] == "[" then
			side = { a = point.a, b = point.b + 1 }
		elseif map[point.a][point.b] == "]" then
			side = { a = point.a, b = point.b - 1 }
		end
		doMove(side, dir, true)
	end
	local there = U.addPoints(point, dir)
	doMove(there, dir, false)
	map[there.a][there.b] = map[point.a][point.b]
	map[point.a][point.b] = "."
end

local function move2(point, dir)
	if canMove(point, dir, false) then
		doMove(point, dir, false)
		return true
	end
	return false
end

map = {}
i = 1

repeat
	local line = mapins[i]
	map[i] = {}
	for j = 1, #line do
		map[i][j] = line:sub(j, j)
	end
	i = i + 1
until line == "" or line == nil

map = widen(map)

for i = 1, #map do
	for j = 1, #map[i] do
		if map[i][j] == "@" then
			start = { a = i, b = j }
			break
		end
	end
end

p = start

for i = 1, #ins do
	local dir = dirs[ins:sub(i, i)]
	if move2(p, dir) then
		p = U.addPoints(p, dir)
	end
end

local function gps2()
	return gps("[")
end

print("Day 15 part 2: " .. gps2())
