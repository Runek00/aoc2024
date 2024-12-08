local U = require("utils")

local dir = U.N

local tab = U.tableTo2DCharArray(U.fileToTable("day6/input.txt"))

local point
for i = 1, #tab do
	for j = 1, #tab[i] do
		if tab[i][j] == "^" then
			point = U.point(i, j)
			goto continue
		end
	end
end
::continue::

local sx, sy = U.tab2DSize(tab)

local step = U.stepFromPoint(point, dir)

local function forward(step)
	local out = {}
	out.a = step.a + step.to.a
	out.b = step.b + step.to.b
	out.to = step.to
	return out
end

local function right(step)
	if step.to == U.N then
		step.to = U.E
	elseif step.to == U.E then
		step.to = U.S
	elseif step.to == U.S then
		step.to = U.W
	else
		step.to = U.N
	end

	return step
end

local visited = {}
visited[step.a .. "|" .. step.b] = true

local count = 1
while step.a > 0 and step.a <= sx and step.b > 0 and step.b <= sy do
	local fwd = forward(step)
	if tab[fwd.a] ~= nil and tab[fwd.a][fwd.b] ~= nil then
		if tab[fwd.a][fwd.b] == "#" then
			step = right(step)
		else
			step = fwd
			if not visited[step.a .. "|" .. step.b] then
				visited[step.a .. "|" .. step.b] = true
				count = count + 1
			end
		end
	else
		break
	end
end

print("day6 part1: " .. count)

step = U.stepFromPoint(point, dir)
visited = {}
local found = false
local used = {}

local function pstr(s)
	return s.a .. "|" .. s.b
end

local function str(s)
	return s.a .. "|" .. s.b .. "|" .. s.to.a .. "|" .. s.to.b
end
local function unstr(s)
	local params = U.split(s, "|")
	return {
		a = tonumber(params[1]),
		b = tonumber(params[2]),
		to = { a = tonumber(params[3]), b = tonumber(params[4]) },
	}
end

used[pstr(point)] = true

count = 0
local function walk()
	visited = {}
	while true do
		if tab[step.a] == nil or tab[step.a][step.b] == nil then
			break
		end
		if visited[str(step)] then
			count = count + 1
			return
		end
		visited[str(step)] = true
		local fwd = forward(step)
		if tab[fwd.a] == nil or tab[fwd.a][fwd.b] == nil then
			break
		end
		if tab[fwd.a][fwd.b] == "#" then
			step = right(step)
		else
			step = fwd
		end
	end
end

walk()
print(count)

local tests = U.cloneTable(visited, {})

count = 0

for k, _ in pairs(tests) do
	st = unstr(k)
	if not used[pstr(st)] then
		step = U.stepFromPoint(point, dir)
		tab[st.a][st.b] = "#"
		walk()
		tab[st.a][st.b] = "."
		used[pstr(st)] = true
	end
end

print("day6 part2: " .. count)
