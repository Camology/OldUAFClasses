-- interpit.lua  
-- Cameron K Titus
-- 4/11/18
--
-- For CS F331 / CSCE A331 Spring 2018
-- Interpret AST from parseit.parse
-- For Assignment 6, Exercise B


-- *******************************************************************
-- * To run a Dugong program, use dugong.lua (which uses this file). *
-- *******************************************************************


local interpit = {}  -- Our module


local STMT_LIST   = 1
local INPUT_STMT  = 2
local PRINT_STMT  = 3
local FUNC_STMT   = 4
local CALL_FUNC   = 5
local IF_STMT     = 6
local WHILE_STMT  = 7
local ASSN_STMT   = 8
local CR_OUT      = 9
local STRLIT_OUT  = 10
local BIN_OP      = 11
local UN_OP       = 12
local NUMLIT_VAL  = 13
local BOOLLIT_VAL = 14
local SIMPLE_VAR  = 15
local ARRAY_VAR   = 16

local function numToInt(n)
	assert(type(n) == "number")

	if n >= 0 then
		return math.floor(n)
	else
		return math.ceil(n)
	end
end

local function strToNum(s)
	assert(type(s) == "string")

	local success, value = pcall(function() return 0+s end)

	if success then
		return numToInt(value)
	else
		return 0
	end
end

local function numToStr(n)
	assert(type(n) == "number")

	return ""..n
end

local function strToBool(str)
	assert(type(str) == "string")
	
	if str == "true" then return true
	else return false
	end
end

local function boolToInt(b)
	assert(type(b) == "boolean")

	if b then
		return 1
	else
		return 0
	end
end

function astToStr(x)
	local symboltheNAMEs = {
		"STMT_LIST", "INPUT_STMT", "PRINT_STMT", "FUNC_STMT",
		"CALL_FUNC", "IF_STMT", "WHILE_STMT", "ASSN_STMT", "CR_OUT",
		"STRLIT_OUT", "BIN_OP", "UN_OP", "NUMLIT_VAL", "BOOLLIT_VAL",
		"SIMPLE_VAR", "ARRAY_VAR"
	}
	if type(x) == "number" then
		local theNAME = symboltheNAMEs[x]
		if theNAME == nil then
			return "<Unknown numerical constant: "..x..">"
		else
			return theNAME
		end
	elseif type(x) == "string" then
		return '"'..x..'"'
	elseif type(x) == "boolean" then
		if x then
			return "true"
		else
			return "false"
		end
	elseif type(x) == "table" then
		local first = true
		local result = "{"
		for k = 1, #x do
			if not first then
				result = result .. ","
			end
			result = result .. astToStr(x[k])
			first = false
		end
		result = result .. "}"
		return result
	elseif type(x) == "nil" then
		return "nil"
	else
		return "<"..type(x)..">"
	end
end

function interpit.interp(ast, state, incall, outcall)
	function interp_stmt_list(ast)
		for i = 2, #ast do
			interp_stmt(ast[i])
		end
	end

	function interp_stmt(ast)
		local theNAME, theBODY, stringCat

		if ast[1] == INPUT_STMT then
			if ast[2][1] == SIMPLE_VAR then
				theNAME = ast[2][2]
				body = incall()
				state.v[theNAME] = numToInt(strToNum(body))
			end
			
		elseif ast[1] == PRINT_STMT then
			for i = 2, #ast do
				if ast[i][1] == CR_OUT then
					outcall("\n")
				elseif ast[i][1] == STRLIT_OUT then
					str = ast[i][2]
					outcall(str:sub(2,str:len()-1))
				else
					body = evalExpr(ast[2])
					outcall(numToStr(body))
				end
			end
			
		elseif ast[1] == FUNC_STMT then
			theNAME = ast[2]
			body = ast[3]
			state.f[theNAME] = body
			
		elseif ast[1] == CALL_FUNC then
			theNAME = ast[2]
			body = state.f[theNAME]
			if body == nil then body = { STMT_LIST } end
			interp_stmt_list(body)
			
		elseif ast[1] == IF_STMT then
			local done = false
			local elseIndex = 0
			
			for i=2, #ast-1, 2 do
				if evalExpr(ast[i]) ~= 0 and not done then
					interp_stmt_list(ast[i+1])
					done = true
				end
				elseIndex = i
			end
			
			if ast[elseIndex+2] ~= nil and not done then
				interp_stmt_list(ast[elseIndex+2])
			end
			
		elseif ast[1] == WHILE_STMT then
			while evalExpr(ast[2]) ~= 0 do
				interp_stmt_list(ast[3])
			end
		
		else
			assert(ast[1] == ASSN_STMT)
			processLvalue(ast)
		end
	end
	
	function processLvalue(ast)
		local theNAME, body
		
		if ast[2][1] == SIMPLE_VAR then
			theNAME = ast[2][2]
			body = evalExpr(ast[3])
			state.v[theNAME] = numToInt(body)
			
		elseif ast[2][1] == ARRAY_VAR then
			theNAME = ast[2][2]
			if state.a[theNAME] == nil then state.a[theNAME] = {} end
			body = evalExpr(ast[3])
			state.a[theNAME][evalExpr(ast[2][3])] = body
		end
	end
	
	function evalExpr(ast)
		local value;
		
		if ast[1] == NUMLIT_VAL then
			value = strToNum(ast[2])
			
		elseif ast[1] == SIMPLE_VAR then
			value = state.v[ast[2]]
			
		elseif ast[1] == ARRAY_VAR then
			if state.a[ast[2]] ~= nil then 
				value = state.a[ast[2]][evalExpr(ast[3])]
			else
				value = 0
			end
			
		elseif ast[1] == BOOLLIT_VAL then
			value = boolToInt(strToBool(ast[2]))
			
		elseif ast[1] == CALL_FUNC then
			interp_stmt(ast)
			value = state.v["return"]
			
		elseif type(ast[1]) == "table" then
			if ast[1][1] == UN_OP then
				local unary = evalExpr(ast[2])
				
				if ast[1][2] == "+" then
					value = unary
					
				elseif ast[1][2] == "-" then
					value = -(unary)
					
				else
					if unary == 0 then
						value = 1
					else
						value = 0
					end
				end
				
			elseif ast[1][1] == BIN_OP then
				local lhs = evalExpr(ast[2])
				local rhs = evalExpr(ast[3])
				local bool = lhs == rhs
				
				if ast[1][2] == "+" then
					value = lhs + rhs
					
				elseif ast[1][2] == "-" then
					value = lhs - rhs
					
				elseif ast[1][2] == "*" then
					value = lhs * rhs
					
				elseif ast[1][2] == "/" then
					if rhs == 0 then value = rhs
					else value = numToInt(lhs / rhs)
					end
					
				elseif ast[1][2] == "%" then
					if rhs == 0 then value = rhs
					else value = numToInt(lhs % rhs)
					end
					
				elseif ast[1][2] == "==" then
					value = boolToInt(lhs == rhs)
					
				elseif ast[1][2] == "!=" then
					value = boolToInt(lhs ~= rhs)
					
				elseif ast[1][2] == "<=" then
					value = boolToInt(lhs <= rhs)
					
				elseif ast[1][2] == ">=" then
					value = boolToInt(lhs >= rhs)
					
				elseif ast[1][2] == "<" then
					value = boolToInt(lhs < rhs)
					
				elseif ast[1][2] == ">" then
					value = boolToInt(lhs > rhs)
					
				elseif ast[1][2] == "&&" then
					if lhs == 0 and rhs == 0 then
						value = 0
					elseif bool then
						value = boolToInt(bool)
					else
						value = boolToInt(bool)
					end
					
				elseif ast[1][2] == "||" then
					if lhs == 0 and rhs == 0 then
						value = 0
					elseif lhs ~= 0 or rhs ~= 0 then
						value = 1
					elseif bool then
						value = boolToInt(bool)
					end
				end
			end
		end
		
		if value == nil then return 0
		else return value
		end
	end
	
	interp_stmt_list(ast)
	return state
end

return interpit