local U = require("utils")

local input = U.fileToTable("day5/input.txt")

local rules = {}

local function parseRule(line)
	local p = tonumber(U.split(line, "|")[1])
	local n = tonumber(U.split(line, "|")[2])
	if p == nil or n == nil then
		return
	end
	if rules[p] == nil then
		rules[p] = { n }
	else
		table.insert(rules[p], n)
	end
end

local i = 1
repeat
	parseRule(input[i])
	i = i + 1
until input[i] == ""

local function checkUpdate(line)
	if line == nil then
		return 0
	end
	local list = U.split(line, ",")
	local used = {}
	for l = 1, #list do
		local num = tonumber(list[l])
		if rules[num] == nil then
			used[num] = true
			goto continue
		end
		for _, v in ipairs(rules[num]) do
			if used[v] == true then
				return 0
			end
		end
		used[num] = true
		::continue::
	end
	return list[math.floor(#list / 2) + 1]
end

i = i + 1
local out = 0
for j = i, #input do
	out = out + checkUpdate(input[j])
end

print("day5 part1: " .. out)

local allrulesmap = {}

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

local function allPairsify(k)
	for _, v in ipairs(allrulesmap[k]) do
		allPairsify(v)
		allrulesmap[k] = addSets(allrulesmap[k], allrulesmap[v])
	end
end

local function allrules(line)
	if line == nil then
		return 0
	end
	local list = U.split(line, ",")
	local set = {}
	for _, num in ipairs(list) do
		set[tonumber(num)] = true
	end

	for k, _ in pairs(set) do
		allrulesmap[k] = {}
		if rules[k] == nil then
			rules[k] = {}
		end
		for _, v in ipairs(rules[k]) do
			if set[v] == true then
				allrulesmap[k][v] = true
			end
		end
	end

	for k, _ in pairs(set) do
		allPairsify(k)
	end
end

local function compare(a, b)
	if allrulesmap[a] == nil then
		return false
	end
	return allrulesmap[a][b] == true
end

out = 0
for j = i, #input do
	local line = input[j]
	if checkUpdate(line) ~= 0 then
		goto continue
	end
	allrulesmap = {}
	allrules(line)
	for _, v in pairs(allrulesmap) do
		local x = ""
		for kk, _ in pairs(v) do
			x = x .. kk .. ","
		end
	end
	local list = U.split(line, ",")
	local nList = {}
	for _, v in ipairs(list) do
		table.insert(nList, tonumber(v))
	end
	local x = ""
	table.sort(nList, compare)
	for _, v in ipairs(nList) do
		x = x .. v .. ","
	end
	out = out + nList[math.floor(#nList / 2) + 1]
	::continue::
end

print("day5 part2: " .. out)
