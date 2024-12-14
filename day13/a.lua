local U = require("utils")

local lines = U.fileToTable("day13/input.txt")

local machines = {}

local function parseForward(str)
	return tonumber(str:sub(3, -1))
end

local function parseButton(line, name)
	local params = U.split(line, name .. ": ")[2]
	local nums = U.split(params, ", ")

	local x = parseForward(nums[1])
	local y = parseForward(nums[2])
	return U.point(x, y)
end

local function parsePrize(line)
	local params = U.split(line, ": ")[2]
	local nums = U.split(params, ", ")
	local x = parseForward(nums[1])
	local y = parseForward(nums[2])
	return U.point(x, y)
end

for i = 1, #lines, 4 do
	local a = parseButton(lines[i], "A")
	local b = parseButton(lines[i + 1], "B")
	local prize = parsePrize(lines[i + 2])
	table.insert(machines, { a = a, b = b, prize = prize })
end

local function multiplyPoint(p1, m)
	return U.point(p1.a * m, p1.b * m)
end

local function anyCloser(point, target)
	return point.a < target.a or point.b < target.b
end

local function calCur(machine, aCounter, bCounter)
	return U.addPoints(multiplyPoint(machine.b, bCounter), multiplyPoint(machine.a, aCounter))
end

local function findCheapestPrize(machine)
	local candidateCost = math.huge
	local aCounter = 0
	local bCounter = 0

	aCounter = math.floor(math.max(machine.prize.a / machine.a.a, machine.prize.b / machine.a.b))
	if anyCloser(calCur(machine, aCounter, bCounter), machine.prize) then
		aCounter = aCounter + 1
	end
	local cur = calCur(machine, aCounter, bCounter)

	while true do
		if cur.a == machine.prize.a and cur.b == machine.prize.b then
			local cost = aCounter * 3 + bCounter
			candidateCost = math.min(candidateCost, cost)
		end
		bCounter = bCounter + 1
		cur = U.addPoints(cur, machine.b)
		if aCounter <= 0 then
			break
		end
		while true do
			if anyCloser(cur, machine.prize) then
				cur = U.addPoints(cur, machine.a)
				aCounter = aCounter + 1
				break
			end
			aCounter = aCounter - 1
			cur = U.addPoints(cur, U.opposite(machine.a))
		end
	end
	if candidateCost == math.huge then
		return 0
	else
		return candidateCost
	end
end

local tokens = 0
for _, m in ipairs(machines) do
	tokens = tokens + findCheapestPrize(m)
end

print("Day 13 part 1: " .. tokens)

local function findCheapestPrize2(machine)
	local q = machine.prize.a
	local w = machine.a.a
	local e = machine.b.a
	local a = machine.prize.b
	local b = machine.a.b
	local c = machine.b.b

	local bCounter = (w * a - q * b) / (w * c - e * b)
	if bCounter % 1 ~= 0 then
		return 0
	end
	local aCounter = (q - bCounter * e) / w
	if aCounter % 1 ~= 0 then
		return 0
	end
	return aCounter * 3 + bCounter
end

tokens = 0
for _, m in ipairs(machines) do
	tokens = tokens + findCheapestPrize2(m)
end
print("Day 13 part 1: " .. tokens)

tokens = 0
for _, m in ipairs(machines) do
	m.prize = U.addPoints(m.prize, U.point(10000000000000, 10000000000000))
	tokens = tokens + findCheapestPrize2(m)
end

print("Day 13 part 2: " .. string.format("%20.0f", tokens))
