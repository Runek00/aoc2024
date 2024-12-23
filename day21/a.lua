local U = require "utils"

local codes = U.fileToTable("day21/test.txt")

local function inNumpad(p)
	print(U.pstr(p))
	if p.a == 4 and p.b == 1 then
		return false
	end
	if p.a < 1 or p.a > 4 or p.b<1 or p.b > 3 then
		return false
	end
	return true
end

local function stepOnNumpad(p1, p2)
	print(U.pstr(p1), U.pstr(p2))
	if U.pstr(p1) == U.pstr(p2) then
		return "", p2
	end
	if p1.a > p2.a then
		local p3 = p1
		p3.a = p1.a - 1
		if inNumpad(p3) then
			return "^", p3
		end
	elseif p1.a < p2.a then
		local p3 = p1
		p3.a = p1.a + 1
		if inNumpad(p3) then
			return "v", p3
		end
	end

	if p1.b > p2.b then
		local p3 = p1
		p3.b = p1.b - 1
		if inNumpad(p3) then
			return "<", p3
		end
	elseif p1.b < p2.b then
		local p3 = p1
		p3.b = p1.b + 1
		if inNumpad(p3) then
			return ">", p3
		end
	end
	print("None")
end

local function goOnNumpad(start, finish)
	local out = ""
	local arr
	local point = start
	print("go: start: " .. start, "finish: " .. finish)
	while U.pstr(point) ~= U.pstr(finish) do
		arr, point = stepOnNumpad(point, finish)
		out = out .. arr
	end
	out = out .. "A"
	return out, finish
end

local numpad = {}
	numpad["1"] = U.point(1,1)
	numpad["2"] = U.point(1,2)
	numpad["3"] = U.point(1,3)
	numpad["4"] = U.point(2,1)
	numpad["5"] = U.point(2,2)
	numpad["6"] = U.point(2,3)
	numpad["7"] = U.point(3,1)
	numpad["8"] = U.point(3,2)
	numpad["9"] = U.point(3,3)
	numpad["0"] = U.point(4,2)
	numpad["A"] = U.point(4,3)

local function moveOnNumpad(start, sequence)
	print("Sequence: " .. sequence)
	if sequence == "" then
		return ""
	end
	print("move: start: " .. start)

	local out = ""
	local sp = numpad[start]
	for i = 1, #sequence do
		local c = string.sub(sequence, i, i)
		print(c)
		local t = numpad[c]
		local arrows
		arrow, sp = goOnNumpad(sp, t)
		print(arrow)
		out = out .. arrows
	end
	return out
end

local function inArrpad(p)
	if p.a == 1 and p.b == 1 then
		return false
	end
	if p.a < 1 or p.a > 2 or p.b<1 or p.b > 3 then
		return false
	end
	return true
end

local function stepOnArrpad(p1, p2)
	if U.pstr(p1) == U.pstr(p2) then
		return "", p2
	end
	if p1.a > p2.a then
		local p3 = p1
		p3.a = p1.a + 1
		if inArrpad(p3) then
			return "v", p3
		end
	elseif p1.a < p2.a then
		local p3 = p1
		p3.a = p1.a - 1
		if inArrpad(p3) then
			return "^", p3
		end
	end

	if p1.b > p2.b then
		local p3 = p1
		p3.b = p1.b + 1
		if inArrpad(p3) then
			return ">", p3
		end
	elseif p1.a < p2.a then
		local p3 = p1
		p3.a = p1.a - 1
		if inArrpad(p3) then
			return "<", p3
		end
	end
end

local function goOnArrpad(start, finish)
	local out = ""
	local arr
	local point = start
	while U.pstr(point) ~= U.pstr(finish) do
		arr, point = stepOnArrpad(point, finish)
		out = out .. arr
	end
	out = out .. "A"
	return out, finish
end

local arrpad = {}
	arrpad["^"] = U.point(1,2)
	arrpad["v"] = U.point(2,2)
	arrpad[">"] = U.point(2,3)
	arrpad["<"] = U.point(2,1)
	arrpad["A"] = U.point(1,3)

local function moveOnArrpad(start, sequence)
	if sequence == "" then
		return ""
	end

	local out = ""
	local sp = arrpad[start]
	for _, c in ipairs(sequence) do
		local t = arrpad[c]
		local arrows
		arrow, sp = goOnArrpad(sp, t)
		out = out .. arrows
	end
	return out
end

local out = 0

for _, code in ipairs(codes) do
	print(code)
	local seq = moveOnNumpad("A", code)
	print(seq)
	--seq = moveOnArrpad("A", seq)
	print(seq)
	--seq = moveOnArrpad("A", seq)
	print(seq)
end
