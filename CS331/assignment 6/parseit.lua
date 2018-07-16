-- Cameron K Titus Assignment 4 
-- CS331 UAF Spring 2018
-- Based on rdparser4 and assn4_code.txt

local parseit = {}

lexit = require "lexit"

-- For lexer iteration
local iter
local state
local lexer_out_s
local lexer_out_c

-- For current lexeme
local lexyString = ""
local lexyCat = 0

-- Symbolic constants for aSearchTree
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


-- Go to next lexeme and load it into lexyString, lexyCat.
-- Should be called once before any parsing is done.
-- Function init must be called before this function is called.
    local function advance()
        -- Advance the iterator
        lexit_out_s, lexit_out_c = iter(state, lexit_out_s)
    
        -- If we're not past the end, copy current lexeme into vars
        if lexit_out_s ~= nil then
            lexyString, lexyCat = lexit_out_s, lexit_out_c
        else
            lexyString, lexyCat = "", 0
        end
    end


-- Return true if pos has reached end of input.
-- Function init must be called before this function is called.
local function atEnd()
    return lexyCat == 0
end


-- Given string, see if current lexeme string form is equal to it. If
-- so, then advance to next lexeme & return true. If not, then do not
-- advance, return false.
-- Function init must be called before this function is called. 
local function matchString(s)
    if lexyString == s then
        if lexyString == ')' then
            lexit.preferOp()
        end
        advance()
        return true
    else
        return false
    end
end


-- Same as matchString, but for categories
local function matchCat(c)
    return lexyCat == c
end


-- Initial call. Sets input for parsing functions.
local function init(prog)
    iter, state, lexer_out_s = lexit.lex(prog)
    advance()
end

function parseit.parse(prog)
    -- Initialization
    init(prog)

    -- Get results from parsing
    local tresBien, aSearchTree = parsePRGRM()  -- Parse start symbol
    local done = atEnd()

    -- And return them
    return tresBien, done, aSearchTree
end

-- Handles print arguments
function parsePRINTARG()
    local tresBien, aSearchTree
    if matchString('cr') then
        aSearchTree = { CR_OUT }
        tresBien = true
    elseif matchCat(lexit.STRLIT) then
        aSearchTree = { STRLIT_OUT, lexyString }
        advance()
        tresBien = true
    else
        tresBien, aSearchTree = parseEXPR()
        if not tresBien then
            return false, nil
        end
        -- advance()
        tresBien = true
    end
    return tresBien, aSearchTree
end

-- parsePRGRM
-- Parsing function for nonterminal "program".
-- Function init must be called before this function is called.
function parsePRGRM()
    local tresBien, aSearchTree
    tresBien, aSearchTree = parseSTMTList()
    return tresBien, aSearchTree
end


-- Parsing function for nonterminal "stmt_list".
-- Function init must be called before this function is called.
function parseSTMTList()
    local tresBien, aSearchTree, secondTree

    aSearchTree = { STMT_LIST }
    while true do
        if lexyString ~= "input"
            and lexyString ~= "print"
            and lexyString ~= "func"
            and lexyString ~= "call"
            and lexyString ~= "if"
            and lexyString ~= "while"
            and lexyCat ~= lexit.ID then
            return true, aSearchTree
        end

        tresBien, secondTree = parseSTMT()
        if not tresBien then
            return false, nil
        end

        table.insert(aSearchTree, secondTree)
    end
    return tresBien, aSearchTree
end


-- Handles call statements
function parseCall()
    local tresBien, aSearchTree
    if matchCat(lexit.ID) then
        aSearchTree = { CALL_FUNC, lexyString }
        tresBien = true
        advance()
    else
        tresBien = false
    end
    return tresBien, aSearchTree
end


-- Handles arithmetic expressions
function parseARITH()
    local tresBien, aSearchTree, secondTree, oldLexyString
    tresBien, aSearchTree = parseTERM()
    if not tresBien then
        return false, nil
    end
    while true do
        oldLexyString = lexyString
        if not matchString('+') and not matchString('-') then
            break
        end
        
        tresBien, secondTree = parseTERM()
        if not tresBien then
            return false, nil
        end
        aSearchTree = { { BIN_OP, oldLexyString }, aSearchTree, secondTree }
    end
    return true, aSearchTree
end


-- Handles expressions
function parseEXPR()
    local tresBien, aSearchTree, secondTree, oldLexyString

    tresBien, aSearchTree = parse_COMP()

    while true do
        oldLexyString = lexyString
        if not matchString("&&") and not matchString("||") then
            break
        end
        tresBien, secondTree = parse_COMP()
        if not tresBien then
            return false, nil
        end
        aSearchTree = { { BIN_OP, oldLexyString }, aSearchTree, secondTree }
    end
    return tresBien, aSearchTree
end


-- Handles comparison expressions
function parse_COMP()
    local tresBien, aSearchTree, secondTree, thirdTree
    if matchString('!') then
        tresBien, aSearchTree = parse_COMP()
        if not tresBien then
            return false, nil
        end
        aSearchTree = { { UN_OP, "!" }, aSearchTree}
        return true, aSearchTree
    end
    tresBien, aSearchTree = parseARITH()
    if not tresBien then
        return false, nil
    end

    while true do
        local oldLexyString = lexyString
        if not matchString("==") 
        and not matchString("!=")
        and not matchString("<")
        and not matchString("<=")
        and not matchString(">")
        and not matchString(">=") then
            return tresBien, aSearchTree
        else
            tresBien, secondTree = parseARITH()
            if not tresBien then
                return false, nil
            end
            aSearchTree = { { BIN_OP, oldLexyString }, aSearchTree, secondTree }
        end
    end
    return tresBien, aSearchTree
end

-- Handles terminals
function parseTERM()
    local tresBien, aSearchTree, secondTree, oldLexyString
    tresBien, aSearchTree = parseFCTR()
    if not tresBien then
        return false, nil
    end
    while true do
        oldLexyString = lexyString
        if not matchString('*')
        and not matchString('/')
        and not matchString('%') then
            break
        end

        tresBien, secondTree = parseFCTR()
        if not tresBien then
            return false, nil
        end
        aSearchTree = { { BIN_OP, oldLexyString }, aSearchTree, secondTree }
    end
    return true, aSearchTree
end


-- Handles factors
function parseFCTR()
    local tresBien, aSearchTree, secondTree, oldLexyString
    oldLexyString = lexyString
    if matchString('call') then
        return parseCall()
    elseif matchString('true') or matchString('false') then
        return true, { BOOLLIT_VAL, oldLexyString }
    elseif matchCat(lexit.NUMLIT) then
        lexit.preferOp()
        tresBien = true
        aSearchTree = { NUMLIT_VAL, lexyString }
        advance()
    elseif matchString('+') or matchString('%') or matchString('-') then
        tresBien, secondTree = parseFCTR()
        if not tresBien then
            return false, nil
        end
        aSearchTree = { {UN_OP, oldLexyString}, secondTree }
    elseif matchString('(') then
        tresBien, aSearchTree = parseEXPR()
        if not tresBien or not matchString(')') then
            return false, nil
        end
    else
        tresBien, aSearchTree = parseLVAL() 
        if not tresBien then
            return false, nil
        end
    end 
    return tresBien, aSearchTree
end



-- Handles lvalues
function parseLVAL()
    local tresBien, aSearchTree
    if matchCat(lexit.ID) then
        lexit.preferOp()
        aSearchTree = { SIMPLE_VAR, lexyString }
        tresBien = true
        advance()
        if matchString('[') then
            local tresBien, secondTree = parseEXPR()
            if not tresBien then
                return false, nil
            end
            aSearchTree = { ARRAY_VAR, aSearchTree[2], secondTree }
            if not matchString(']') then
                return false, nil
            end
        end
    else
        tresBien = false
    end
    return tresBien, aSearchTree
end

-- Parsing function for nonterminal "statement"
-- Function init must be called before this function is called.
function parseSTMT()
    local tresBien, aSearchTree, secondTree, oldLexyString

-- Input statements
    if matchString("input") then
        tresBien, aSearchTree = parseLVAL()
        return tresBien, { INPUT_STMT, aSearchTree }

-- Call statements
    elseif matchString('call') then
        tresBien, aSearchTree = parseCall()
        return tresBien, aSearchTree

-- Print statements
    elseif matchString("print") then
        tresBien, aSearchTree = parsePRINTARG()
        if not tresBien then
            return false, nil
        end

        secondTree = { PRINT_STMT, aSearchTree }

        while true do
            if not matchString(";") then
                break
            end

            tresBien, aSearchTree = parsePRINTARG()
            if not tresBien then
                return false, nil
            end

            table.insert(secondTree, aSearchTree)
        end
        return true, secondTree

-- Func definitions
    elseif matchString("func") then
        local func_name
        if matchCat(lexit.ID) then
            func_name = lexyString
            advance()
        else
            return false, nil
        end
        tresBien, secondTree = parseSTMTList()
        if not tresBien then
            return false, nil
        end
        tresBien = matchString('end')
        aSearchTree = { FUNC_STMT, func_name, secondTree }
        return tresBien, aSearchTree

-- While statements
    elseif matchString('while') then
        local expr, stmt_list
        tresBien, expr = parseEXPR()
        if not tresBien then
            return false, nil
        end
        tresBien, stmt_list = parseSTMTList()
        if not tresBien or not matchString('end') then
            return false, nil
        end
        aSearchTree = { WHILE_STMT, expr, stmt_list }
        return true, aSearchTree

-- If statements
    elseif matchString('if') then
        local expr, stmt_list
        tresBien, expr = parseEXPR()
        if not tresBien then
            return false, nil
        end
        tresBien, stmt_list = parseSTMTList()
        if not tresBien then
            return false, nil
        end
        aSearchTree = { IF_STMT, expr, stmt_list }
        while true do
            oldLexyString = lexyString
            if not matchString('elseif') then
                break
            end
            tresBien, expr = parseEXPR()
            if not tresBien then
                return false, nil
            end
            tresBien, stmt_list = parseSTMTList()
            if not tresBien then
                return false, nil
            end
            table.insert(aSearchTree, expr)
            table.insert(aSearchTree, stmt_list)
        end
        if matchString('else') then
            tresBien, stmt_list = parseSTMTList()
            if not tresBien then
                return false, nil
            end
            table.insert(aSearchTree, stmt_list)
        end
        if not matchString('end') then
            return false, nil
        end
        return true, aSearchTree

    -- Handle assignments
    elseif matchCat(lexit.ID) then
        tresBien, aSearchTree = parseLVAL()
        if not tresBien then
            return false, nil
        end
        if not matchString('=') then
            return false, nil
        end
        tresBien, secondTree = parseEXPR()
        if not tresBien then
            return false, nil
        end
        aSearchTree = { ASSN_STMT, aSearchTree, secondTree }
        return true, aSearchTree

    -- Handle unknown cases
    else
        advance()
        return false, nil
    end
end

return parseit

