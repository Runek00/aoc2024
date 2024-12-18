local U = require("utils")

local input = U.fileToTable("day17/input.txt")

Registers = {}

for i = 1, 3 do
	local rv = U.split(input[i], ": ")
	Registers[string.sub(rv[1], -1)] = tonumber(rv[2])
end

local program = U.tabToNum(U.split(U.split(input[5], ": ")[2], ","))
print("Registers: " .. "A: " .. Registers.A .. " B: " .. Registers.B .. " C: " .. Registers.C)
print(U.printTable(program))

local pOut = U.split(input[5], ": ")[2] .. ","

i = 1
local output = ""

local instr = {}

local function combo(pos)
	local op = program[pos]
	if op <= 3 then
		return op
	elseif op == 4 then
		return Registers["A"]
	elseif op == 5 then
		return Registers["B"]
	elseif op == 6 then
		return Registers["C"]
	end
end

instr[0] = function()
	local operand = combo(i + 1)
	Registers.A = math.floor(Registers.A / (2 ^ operand))
end

instr[1] = function()
	local operand = program[i + 1]
	Registers.B = Registers.B ~ operand
end

instr[2] = function()
	local operand = combo(i + 1)
	Registers.B = operand % 8
end

instr[3] = function()
	local operand = program[i + 1]
	if Registers.A ~= 0 then
		i = operand + 1
		i = i - 2
	end
end

instr[4] = function()
	Registers.B = Registers.B ~ Registers.C
end

instr[5] = function()
	local operand = combo(i + 1)
	output = output .. operand % 8 .. ","
end

instr[6] = function()
	local operand = combo(i + 1)
	Registers.B = math.floor(Registers.A / (2 ^ operand))
end

instr[7] = function()
	local operand = combo(i + 1)
	Registers.C = math.floor(Registers.A / (2 ^ operand))
end

while i < #program do
	instr[program[i]]()
	i = i + 2
end

print("Registers: " .. "A: " .. Registers.A .. " B: " .. Registers.B .. " C: " .. Registers.C)

print("Day 17 part 1: " .. string.sub(output, 1, -2))

local rega = 1
while true do
	Registers.A = rega
	Registers.B = 0
	Registers.C = 0
	i = 1
	output = ""
	while i < #program and (output == "" or output == string.sub(pOut, 1, #output)) do
		instr[program[i]]()
		i = i + 2
	end
	if output == pOut then
		print("Day 17 part 2: " .. rega)
		break
	end
	if rega % 10000000 == 0 or #output > 20 then
		print("testing: " .. rega)
		print(output)
	end
	rega = rega + 1
end
