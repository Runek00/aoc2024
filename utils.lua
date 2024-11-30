function fileToTable(path)
	local file = io.open(path, "r")
	local lines = {}
	if not file then
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

function fileToString(path)
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

function tableTo2DCharArray(table)
	local charArray = {}
	for i = 1, #table do
		charArray[i] = {}
		for j = 1, #table[i] do
			charArray[i][j] = string.sub(table[i], j, j)
		end
	end
	return charArray
end

function tab2DSize(tab)
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

function lcm(num1, num2)
	return math.abs(num1 * num2) / gcd(num1, num2)
end

function gcd(num1, num2)
	if num1 == 0 or num2 == 0 then
		return num1 + num2
	end
	absN1 = math.abs(num1)
	absN2 = math.abs(num2)
	bigger = math.max(absN1, absN2)
	smaller = math.min(absN1, absN2)
	return gcd(bigger % smaller, smaller)
end

function inTab(point, tab)
	return point.a >= 1 and point.a <= #tab and point.b >= 1 and point.b <= #tab[0]
end

function point(a, b)
	return { a = a, b = b }
end

function step(point, from)
	return { a = point.a, b = point.b, from = from }
end

function step(a, b, from)
	return { a = a, b = b, from = from }
end

N = point(-1, 0)
S = point(1, 0)
E = point(0, 1)
W = point(0, -1)

function opposite(direction)
	return { a = -direction.a, b = -direction.b }
end

function getAllDirections()
	return { N, S, E, W }
end

local M = {}
M.fileToTable = fileToTable
M.fileToString = fileToString
M.tableTo2DCharArray = tableTo2DCharArray
M.tab2DSize = tab2DSize
M.lcm = lcm
M.gcd = gcd
M.inTab = inTab
M.point = point
M.step = step
M.opposite = opposite
M.getAllDirections = getAllDirections
M.N = N
M.S = S
M.E = E
M.W = W
return M
