local U = require("utils")

local lines = U.fileToTable("day14/input.txt")

local function parsePoint(pstr)
	local ab = U.split(pstr, ",")
	return U.point(tonumber(ab[2]), tonumber(ab[1]))
end

local function parseRobot(line)
	local pv = U.split(line, " ")
	local p = U.addPoints(parsePoint(string.sub(pv[1], 3)), U.point(1, 1))
	local v = parsePoint(string.sub(pv[2], 3))
	return U.step(p.a, p.b, v)
end

local robots = U.map(lines, parseRobot)

local function printRobots()
	for _, r in ipairs(robots) do
		if r.to == nil then
			print("no velocity for " .. U.pstr(r))
		end
		print(U.str(r))
	end
end

local space = { w = 101, h = 103 }
local time = 100

local function printRobotsPic()
	local pic = {}
	for i = 1, space.h do
		pic[i] = {}
		for j = 1, space.w do
			pic[i][j] = "."
		end
	end
	for _, r in ipairs(robots) do
		if pic[r.a][r.b] == "." then
			pic[r.a][r.b] = 1
		else
			pic[r.a][r.b] = pic[r.a][r.b] + 1
		end
	end
	for i = 1, space.h do
		local l = ""
		for j = 1, #pic[i] do
			l = l .. pic[i][j]
		end
		print(l)
	end
end

for _ = 1, time do
	for i, r in ipairs(robots) do
		r = U.forward(r)
		if r.a < 1 then
			r.a = space.h + r.a
		end
		if r.a > space.h then
			r.a = r.a - space.h
		end
		if r.b < 1 then
			r.b = space.w + r.b
		end
		if r.b > space.w then
			r.b = r.b - space.w
		end
		robots[i] = r
	end
end

local quadrants = { q = 0, w = 0, e = 0, r = 0 }
for _, r in ipairs(robots) do
	if r.a > math.ceil(space.h / 2) then
		if r.b > math.ceil(space.w / 2) then
			quadrants.r = quadrants.r + 1
		elseif r.b < math.ceil(space.w / 2) then
			quadrants.e = quadrants.e + 1
		end
	elseif r.a < math.ceil(space.h / 2) then
		if r.b > math.ceil(space.w / 2) then
			quadrants.q = quadrants.q + 1
		elseif r.b < math.ceil(space.w / 2) then
			quadrants.w = quadrants.w + 1
		end
	end
end

local safetyFactor = quadrants.q * quadrants.w * quadrants.e * quadrants.r
print("Day 14, part 1: " .. safetyFactor)

robots = U.map(lines, parseRobot)

time = 10000

for t = 1, time do
	for i, r in ipairs(robots) do
		r = U.forward(r)
		if r.a < 1 then
			r.a = space.h + r.a
		end
		if r.a > space.h then
			r.a = r.a - space.h
		end
		if r.b < 1 then
			r.b = space.w + r.b
		end
		if r.b > space.w then
			r.b = r.b - space.w
		end
		robots[i] = r
	end

	if t >= 7800 and t <= 8200 then
		print("time " .. t)
		printRobotsPic()
	end
	--os.execute("sleep 0.1")
end
