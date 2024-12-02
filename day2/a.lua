local U = require("utils")

local function allNum(line)
	local t = U.split(line, " ")
	local out = {}
	for _, v in ipairs(t) do
		table.insert(out, tonumber(v))
	end
	return out
end

local function safeNums(sn)
	local dir
	for i = 2, #sn do
		local up

		local n1 = sn[i - 1]
		local n2 = sn[i]
		if math.abs(n1 - n2) > 3 then
			return false
		end
		if n1 < n2 then
			up = true
		elseif n1 > n2 then
			up = false
		else
			return false
		end
		if dir == nil then
			dir = up
		else
			if dir ~= up then
				return false
			end
		end
	end
	return true
end

local function s(line)
	local sn = allNum(line)
	return safeNums(sn)
end

local lines = U.fileToTable("day2/input.txt")
local safe = 0
for _, line in ipairs(lines) do
	if s(line) then
		safe = safe + 1
	end
end

print("day 2 part 1", safe)

local function s2(line)
	local sn = allNum(line)
	for i = 1, #sn do
		local l
		if i == 1 then
			l = table.move(sn, 2, #sn, 1, {})
		elseif i == #line then
			l = table.move(sn, 1, #sn - 1, 1, {})
		else
			l = table.move(sn, 1, i - 1, 1, {})
			l = table.move(sn, i + 1, #sn, i, l)
		end
		if safeNums(l) then
			return true
		end
	end
	return false
end

safe = 0
for _, line in ipairs(lines) do
	if s2(line) then
		safe = safe + 1
	end
end

print("day 2 part 2", safe)
