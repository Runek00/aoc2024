local U = require("utils")

local function isXMAS(q, w, e, r)
	return (q == "X" and w == "M" and e == "A" and r == "S") or (q == "S" and w == "A" and e == "M" and r == "X")
end

local t1 = U.fileToTable("day4/input.txt")

local tab = {}
for i, v in ipairs(t1) do
	tab[i] = U.split(v, "")
end

local count = 0
for i = 1, #tab do
	for j = 1, #tab[i] - 3 do
		if isXMAS(tab[i][j], tab[i][j + 1], tab[i][j + 2], tab[i][j + 3]) then
			count = count + 1
		end
	end
end

for i = 1, #tab - 3 do
	for j = 1, #tab[i] do
		if isXMAS(tab[i][j], tab[i + 1][j], tab[i + 2][j], tab[i + 3][j]) then
			count = count + 1
		end
	end
end

for i = 4, #tab do
	for j = 1, #tab[i] - 3 do
		if isXMAS(tab[i][j], tab[i - 1][j + 1], tab[i - 2][j + 2], tab[i - 3][j + 3]) then
			count = count + 1
		end
	end
end

for i = 1, #tab - 3 do
	for j = 1, #tab[i] - 3 do
		if isXMAS(tab[i][j], tab[i + 1][j + 1], tab[i + 2][j + 2], tab[i + 3][j + 3]) then
			count = count + 1
		end
	end
end

print("day 4 part 1: " .. count)

count = 0

local function isX_MAS(t)
	if t[2][2] ~= "A" then
		return false
	end
	if #t ~= 3 or #t[1] ~= 3 then
	return false
	end
	if (t[1][1] == "M" and t[3][3] == "S") or (t[3][3] == "M" and t[1][1] == "S") then
	if (t[1][3] == "M" and t[3][1] == "S") or (t[3][1] == "M" and t[1][3] == "S") then
		return true
	end
	end
end

local function subTable3(t,q,w)
	local out = {}
	for i = 1, 3 do
		out[i] = {}
	end
	for i = 1, 3 do
		for j = 1, 3 do
			out[i][j] = t[i + q - 1][j + w - 1]
		end
	end
	return out
end

for i = 1, #tab-2 do
	for j = 1, #tab[i] - 2 do
		if isX_MAS(subTable3(tab,i,j))then
			count = count + 1
		end
	end
end

print("day 4 part 2: " .. count)
