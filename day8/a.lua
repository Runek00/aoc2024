local U = require("utils")

local tab = U.tableTo2DCharArray(U.fileToTable("day8/input.txt"))

local function dist(point1, point2)
	return { a = point2.a - point1.a, b = point2.b - point1.b }
end

local function add(point, dist)
	return { a = point.a + dist.a, b = point.b + dist.b }
end

local function negate(point)
	return { a = -point.a, b = -point.b }
end

local function equals(point1, point2)
	return point1.a == point2.a and point1.b == point2.b
end

local function reduce(point)
	local gcd = U.gcd(point.a, point.b)
	return U.point(point.a / gcd, point.b / gcd)
end

local antennas = {}

for i = 1, #tab do
	for j = 1, #tab[i] do
		local s = tab[i][j]
		if s ~= "." then
			if antennas[s] == nil then
				antennas[s] = {}
			end
			table.insert(antennas[s], { a = i, b = j })
		end
	end
end

local antinodes = {}

for _, l in pairs(antennas) do
	for i = 1, #l - 1 do
		for j = i + 1, #l do
			local d = dist(l[i], l[j])
			local a = add(l[j], d)
			if U.pointInBounds(a, tab) then
				antinodes[U.pstr(a)] = true
			end
			local b = add(l[i], negate(d))
			if U.pointInBounds(b, tab) then
				antinodes[U.pstr(b)] = true
			end
		end
	end
end

print("day 8 part 1: " .. U.setSize(antinodes))

antinodes = {}

for _, l in pairs(antennas) do
	for i = 1, #l - 1 do
		for j = i + 1, #l do
			antinodes[U.pstr(l[i])] = true
			antinodes[U.pstr(l[j])] = true
			local d = reduce(dist(l[i], l[j]))
			local a = add(l[j], d)
			while U.pointInBounds(a, tab) do
				if not U.pointInBounds(a, tab) then
					break
				end
				antinodes[U.pstr(a)] = true
				a = add(a, d)
			end
			d = negate(d)
			local b = add(l[i], d)
			while U.pointInBounds(b, tab) do
				if not U.pointInBounds(b, tab) then
					break
				end
				antinodes[U.pstr(b)] = true
				b = add(b, d)
			end
		end
	end
end

print("day 8 part 2: " .. U.setSize(antinodes))
