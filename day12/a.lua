local U = require("utils")

local map = U.tableTo2DCharArray(U.fileToTable("day12/input.txt"))
local regionsMap = {}
local regions = {}

local addRegion = function(a, b)
	if b == nil then
		return a
	end
	if b.id ~= nil and b.id ~= a.id then
		return a
	end
	local out = {
		id = a.id,
		size = a.size + b.size,
		borders = a.borders + b.borders,
		points = U.addSets(a.points, b.points),
		plant = a.plant,
	}
	return out
end

local visited = {}
local idCounter = 1

local function walkRegion(point, id)
	if not U.pointInBounds(point, map) then
		return nil
	end

	if visited[U.pstr(point)] then
		return nil
	end

	if id == nil then
		id = idCounter
		idCounter = idCounter + 1
	end
	regionsMap[U.pstr(point)] = id

	visited[U.pstr(point)] = true
	local region = {
		id = id,
		size = 1,
		borders = 0,
		points = { U.pstr(point) },
		plant = map[point.a][point.b],
	}
	for _, dir in ipairs(U.getAllDirections()) do
		local p = U.addPoints(point, dir)
		if U.pointInBounds(p, map) and map[p.a][p.b] == region.plant then
			region = addRegion(region, walkRegion(p, id))
		else
			region.borders = region.borders + 1
		end
	end
	return region
end

for i = 1, #map do
	for j = 1, #map[i] do
		if regionsMap[i] == nil then
			regionsMap[i] = {}
		end
		if regionsMap[i][j] == nil then
			local region = walkRegion({ a = i, b = j }, nil)
			if region ~= nil then
				regions[region.id] = region
				regionsMap[i][j] = region.id
			end
		end
	end
end

local result = 0

for _, region in pairs(regions) do
	result = result + (region.size * region.borders)
end

print("day 12 part 1: " .. string.format("%20.0f", result))

local sideCounter = {}
local function nameRegion(point)
	if not U.pointInBounds(point, map) then
		return nil
	else
		return regionsMap[U.pstr(point)]
	end
end

local function printable(id)
	if id == nil then
		return "nil"
	else
		return id
	end
end

for i = 0, #map do
	local old = { r1 = nil, r2 = nil }
	for j = 1, #map[1] do
		local p1 = { a = i, b = j }
		local p2 = { a = i + 1, b = j }
		local cur = { r1 = nameRegion(p1), r2 = nameRegion(p2) }
		if old.r1 ~= cur.r1 and cur.r1 ~= cur.r2 then
			sideCounter[cur.r1] = (sideCounter[cur.r1] or 0) + 1
			if old.r1 == old.r2 and old.r2 == cur.r2 and cur.r2 ~= nil then
				sideCounter[cur.r2] = (sideCounter[cur.r2] or 0) + 1
			end
		end
		if old.r2 ~= cur.r2 and cur.r1 ~= cur.r2 then
			sideCounter[cur.r2] = (sideCounter[cur.r2] or 0) + 1
			if old.r1 == old.r2 and old.r1 == cur.r1 and cur.r1 ~= nil then
				sideCounter[cur.r1] = (sideCounter[cur.r1] or 0) + 1
			end
		end
		old = cur
	end
end

for j = 0, #map[1] do
	local old = { r1 = nil, r2 = nil }
	for i = 1, #map do
		local p1 = { a = i, b = j }
		local p2 = { a = i, b = j + 1 }
		local cur = { r1 = nameRegion(p1), r2 = nameRegion(p2) }
		if old.r1 ~= cur.r1 and cur.r1 ~= cur.r2 then
			sideCounter[cur.r1] = (sideCounter[cur.r1] or 0) + 1
			if old.r1 == old.r2 and old.r2 == cur.r2 and cur.r2 ~= nil then
				sideCounter[cur.r2] = (sideCounter[cur.r2] or 0) + 1
			end
		end
		if old.r2 ~= cur.r2 and cur.r1 ~= cur.r2 then
			sideCounter[cur.r2] = (sideCounter[cur.r2] or 0) + 1
			if old.r1 == old.r2 and old.r1 == cur.r1 and cur.r1 ~= nil then
				sideCounter[cur.r1] = (sideCounter[cur.r1] or 0) + 1
			end
		end
		old = cur
	end
end

local result2 = 0
sideCounter["nil"] = nil
for r, count in pairs(sideCounter) do
	result2 = result2 + (count * regions[r].size)
end
print("day 12 part 2: " .. string.format("%20.0f", result2))
