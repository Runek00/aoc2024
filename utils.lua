local function fileToTable(path)
	local file = io.open(path, "r")
	local lines = {}
	if not file then
		print("File not found: " .. path)
		return lines
	end
	local i = 1
	for line in file:lines() do
		lines[i] = line
		i = i + 1
	end
	file:close()
	return lines
end

local function fileToString(path)
	local file = io.open(path, "r")
	local str = ""
	if not file then
		return str
	end
	for line in file:lines() do
		str = str .. line .. "\n"
	end
	file:close()
	return str
end

local function tableTo2DCharArray(table)
	local charArray = {}
	for i = 1, #table do
		charArray[i] = {}
		for j = 1, #table[i] do
			charArray[i][j] = string.sub(table[i], j, j)
		end
	end
	return charArray
end

local function tab2DSize(tab)
	if #tab == 0 then
		return 0, 0
	end
	local y = #tab[1]
	for i = 1, #tab do
		if #tab[i] > y then
			y = #tab[i]
		end
	end
	return #tab, y
end

local function gcd(num1, num2)
	if num1 == 0 or num2 == 0 then
		return num1 + num2
	end
	local absN1 = math.abs(num1)
	local absN2 = math.abs(num2)
	local bigger = math.max(absN1, absN2)
	local smaller = math.min(absN1, absN2)
	return gcd(bigger % smaller, smaller)
end

local function lcm(num1, num2)
	return math.abs(num1 * num2) / gcd(num1, num2)
end

local function pointInBounds(point, tab)
	return point.a >= 1 and point.a <= #tab and point.b >= 1 and point.b <= #tab[1]
end

local function point(a, b)
	local out = {}
	out.a = a
	out.b = b
	return out
end

local function stepFromPoint(pt, to)
	return { a = pt.a, b = pt.b, to = to }
end

local function step(a, b, to)
	return { a = a, b = b, to = to }
end

N = point(-1, 0)
S = point(1, 0)
E = point(0, 1)
W = point(0, -1)

local function opposite(direction)
	return { a = -direction.a, b = -direction.b }
end

local function getAllDirections()
	return { N, S, E, W }
end

local function split(source, sep)
	local result, i = {}, 1
	while true do
		local a, b = source:find(sep)
		if not a then
			break
		end
		local candidat = source:sub(1, a - 1)
		if candidat ~= "" then
			result[i] = candidat
		end
		i = i + 1
		source = source:sub(b + 1)
	end
	if source ~= "" then
		result[i] = source
	end
	return result
end

local function addSets(a, b)
	local out = {}
	for k, _ in pairs(a) do
		out[k] = true
	end
	for k, _ in pairs(b) do
		out[k] = true
	end
	return out
end

local function setIntersect(s1, s2)
	local out = {}
	for k, _ in pairs(s1) do
		if s2[k] then
			out[k] = true
		end
	end
	return out
end

local function cloneTable(src, dest)
	if dest == nil then
		dest = {}
	end
	for k, v in pairs(src) do
		dest[k] = v
	end
	return dest
end

local function copyTable2D(src, dest)
	if dest == nil then
		dest = {}
	end
	for i = 1, #src do
		if dest[i] == nil then
			dest[i] = {}
		end
		for j = 1, #src[i] do
			dest[i][j] = src[i][j]
		end
	end
	return dest
end

local function setSize(set)
	local c = 0
	for _, _ in pairs(set) do
		c = c + 1
	end
	return c
end

local function pstr(s)
	return s.a .. "|" .. s.b
end

local function unpstr(s)
	local params = split(s, "|")
	return {
		a = tonumber(params[1]),
		b = tonumber(params[2]),
	}
end

local function str(s)
	return s.a .. "|" .. s.b .. "|" .. s.to.a .. "|" .. s.to.b
end

local function unstr(s)
	local params = split(s, "|")
	return {
		a = tonumber(params[1]),
		b = tonumber(params[2]),
		to = { a = tonumber(params[3]), b = tonumber(params[4]) },
	}
end

local function printTable(tab)
	local l = ""
	for i = 1, #tab do
		l = l .. tab[i] .. ", "
	end
	print(l)
end

local function map(tab, func)
	local out = {}
	for i = 1, #tab do
		out[i] = func(tab[i])
	end
	return out
end

local function mapXD(tab, dim, func)
	local out = {}
	if dim == 1 then
		out = map(tab, func)
	else
		for i = 1, #tab do
			out[i] = mapXD(tab[i], dim - 1, func)
		end
	end
	return out
end

local function tabToNum(tab)
	return map(tab, tonumber)
end

local M = {}
M.fileToTable = fileToTable
M.fileToString = fileToString
M.tableTo2DCharArray = tableTo2DCharArray
M.tab2DSize = tab2DSize
M.lcm = lcm
M.gcd = gcd
M.point = point
M.stepFromPoint = stepFromPoint
M.step = step
M.opposite = opposite
M.getAllDirections = getAllDirections
M.N = N
M.S = S
M.E = E
M.W = W
M.split = split
M.addSets = addSets
M.setIntersect = setIntersect
M.tabToNum = tabToNum
M.cloneTable = cloneTable
M.copyTable2D = copyTable2D
M.setSize = setSize
M.pointInBounds = pointInBounds
M.pstr = pstr
M.unpstr = unpstr
M.str = str
M.unstr = unstr
M.printTable = printTable
M.map = map
M.mapXD = mapXD
return M
