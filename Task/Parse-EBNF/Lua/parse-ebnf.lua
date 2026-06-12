-- EBNF Parser in Lua

local EBNFParser = {}
EBNFParser.__index = EBNFParser

function EBNFParser:new()
    local self = setmetatable({}, EBNFParser)
    self.src = ""
    self.ch = ""
    self.sdx = 1  -- Lua uses 1-based indexing
    self.token = nil
    self.err = false
    self.idents = {}
    self.ididx = {}
    self.productions = {}
    self.extras = {}
    self.results = {"pass", "fail"}
    return self
end

function EBNFParser:btoi(b)
    return b and 1 or 0
end

function EBNFParser:invalid(msg)
    self.err = true
    print(msg)
    self.sdx = #self.src + 1  -- set to eof
    return -1
end

function EBNFParser:skipSpaces()
    while self.sdx <= #self.src do
        self.ch = self.src:sub(self.sdx, self.sdx)
        if not self.ch:match("[ \t\r\n]") then
            break
        end
        self.sdx = self.sdx + 1
    end
end

function EBNFParser:getToken()
    self:skipSpaces()
    if self.sdx > #self.src then
        self.token = {value = -1, isSequence = false}
        return
    end

    local tokstart = self.sdx
    if self.ch:match("[{}()%[%]|=.;]") then
        self.sdx = self.sdx + 1
        self.token = {value = self.ch, isSequence = false}
    elseif self.ch == '"' or self.ch == "'" then
        local closech = self.ch
        local tokend = tokstart + 1
        while tokend <= #self.src and self.src:sub(tokend, tokend) ~= closech do
            tokend = tokend + 1
        end
        if tokend > #self.src then
            self.token = {value = self:invalid("no closing quote"), isSequence = false}
        else
            self.sdx = tokend + 1
            self.token = {
                value = {"terminal", self.src:sub(tokstart + 1, tokend - 1)},
                isSequence = true
            }
        end
    elseif self.ch:match("[a-z]") then
        -- Identifiers are strictly a-z only
        while self.sdx <= #self.src and self.ch:match("[a-z]") do
            self.sdx = self.sdx + 1
            if self.sdx <= #self.src then
                self.ch = self.src:sub(self.sdx, self.sdx)
            end
        end
        self.token = {
            value = {"ident", self.src:sub(tokstart, self.sdx - 1)},
            isSequence = true
        }
    else
        self.token = {value = self:invalid("invalid ebnf"), isSequence = false}
    end
end

function EBNFParser:matchToken(expectedCh)
    if self.token.value ~= expectedCh then
        self.token = {
            value = self:invalid("invalid ebnf (" .. expectedCh .. " expected)"),
            isSequence = false
        }
    else
        self:getToken()
    end
end

function EBNFParser:addIdent(ident)
    for i, id in ipairs(self.idents) do
        if id == ident then
            return i
        end
    end
    table.insert(self.idents, ident)
    local k = #self.idents
    table.insert(self.ididx, -1)
    return k
end

function EBNFParser:factor()
    local res
    if self.token.isSequence then
        local t = self.token.value
        if t[1] == "ident" then
            local idx = self:addIdent(t[2])
            table.insert(t, idx)
            self.token.value = t
        end
        res = self.token.value
        self:getToken()
    elseif self.token.value == "[" then
        self:getToken()
        res = {"optional", self:expression()}
        self:matchToken("]")
    elseif self.token.value == "(" then
        self:getToken()
        res = self:expression()
        self:matchToken(")")
    elseif self.token.value == "{" then
        self:getToken()
        res = {"repeat", self:expression()}
        self:matchToken("}")
    else
        error("invalid token in factor() function")
    end

    if type(res) == "table" and #res == 1 then
        return res[1]
    end
    return res
end

function EBNFParser:term()
    local res = {self:factor()}
    local tokens = {-1, "|", ".", ";", ")", "]", "}"}

    while true do
        local found = false
        for _, token in ipairs(tokens) do
            if self.token.value == token then
                found = true
                break
            end
        end
        if found then
            break
        end
        table.insert(res, self:factor())
    end

    if #res == 1 then
        return res[1]
    end
    return res
end

function EBNFParser:expression()
    local res = {self:term()}
    if self.token.value == "|" then
        res = {"or", res[1]}
        while self.token.value == "|" do
            self:getToken()
            table.insert(res, self:term())
        end
    end

    if #res == 1 then
        return res[1]
    end
    return res
end

function EBNFParser:production()
    self:getToken()
    if self.token.value ~= "}" then
        if self.token.value == -1 then
            return self:invalid("invalid ebnf (missing closing })")
        end
        if not self.token.isSequence then
            return -1
        end

        local t = self.token.value
        if t[1] ~= "ident" then
            return -1
        end

        local ident = t[2]
        local idx = self:addIdent(ident)
        self:getToken()
        self:matchToken("=")
        if self.token.value == -1 then
            return -1
        end

        table.insert(self.productions, {ident, idx, self:expression()})
        self.ididx[idx] = #self.productions
    end

    return self.token.value
end

function EBNFParser:parse(ebnf)
    print("parse:\n" .. ebnf .. " ===>")
    self.err = false
    self.src = ebnf
    self.sdx = 1
    self.idents = {}
    self.ididx = {}
    self.productions = {}
    self.extras = {}

    self:getToken()
    if self.token.isSequence then
        local t = self.token.value
        t[1] = "title"
        table.insert(self.extras, self.token.value)
        self:getToken()
    end

    if self.token.value ~= "{" then
        return self:invalid("invalid ebnf (missing opening {)")
    end

    while true do
        local tokenResult = self:production()
        if tokenResult == "}" or tokenResult == -1 then
            break
        end
    end

    self:getToken()
    if self.token.isSequence then
        local t = self.token.value
        t[1] = "comment"
        table.insert(self.extras, self.token.value)
        self:getToken()
    end

    if self.token.value ~= -1 then
        return self:invalid("invalid ebnf (missing eof?)")
    end

    if self.err then
        return -1
    end

    local k = -1
    for i = 1, #self.ididx do
        if self.ididx[i] == -1 then
            k = i
            break
        end
    end
    if k ~= -1 then
        return self:invalid("invalid ebnf (undefined:" .. self.idents[k] .. ")")
    end

    self:pprint(self.productions, "productions")
    self:pprint(self.idents, "idents")
    self:pprint(self.ididx, "ididx")
    self:pprint(self.extras, "extras")
    return 1
end

-- Simple JSON-like serialization for Lua tables
local function serialize(t, depth)
    depth = depth or 0
    if type(t) ~= "table" then
        if type(t) == "string" then
            return '"' .. t .. '"'
        else
            return tostring(t)
        end
    end

    local result = "{"
    local first = true
    for i, v in ipairs(t) do
        if not first then
            result = result .. ", "
        end
        result = result .. serialize(v, depth + 1)
        first = false
    end
    result = result .. "}"
    return result
end

function EBNFParser:pprint(ob, header)
    print("\n" .. header .. ":")
    local pp = serialize(ob)
    print(pp)
end

function EBNFParser:applies(rule)
    local wasSdx = self.sdx  -- in case of failure
    local r1 = rule[1]

    if type(r1) ~= "string" then
        for i = 1, #rule do
            if not self:applies(rule[i]) then
                self.sdx = wasSdx
                return false
            end
        end
    elseif r1 == "terminal" then
        self:skipSpaces()
        local r2 = rule[2]
        for i = 1, #r2 do
            if self.sdx > #self.src or self.src:sub(self.sdx, self.sdx) ~= r2:sub(i, i) then
                self.sdx = wasSdx
                return false
            end
            self.sdx = self.sdx + 1
        end
    elseif r1 == "or" then
        for i = 2, #rule do
            if self:applies(rule[i]) then
                return true
            end
        end
        self.sdx = wasSdx
        return false
    elseif r1 == "repeat" then
        while self:applies(rule[2]) do
            -- continue repeating
        end
    elseif r1 == "optional" then
        self:applies(rule[2])
    elseif r1 == "ident" then
        local i = rule[3]
        local ii = self.ididx[i]
        if not self:applies(self.productions[ii][3]) then
            self.sdx = wasSdx
            return false
        end
    else
        error("invalid rule in applies() function")
    end

    return true
end

function EBNFParser:checkValid(test)
    self.src = test
    self.sdx = 1
    local res = self:applies(self.productions[1][3])
    self:skipSpaces()
    if self.sdx <= #self.src then
        res = false
    end
    print('"' .. test .. '", ' .. self.results[1 + self:btoi(not res)])
end

-- Main execution
local parser = EBNFParser:new()

local ebnfs = {
    '"a" {\n' ..
    '    a = "a1" ( "a2" | "a3" ) { "a4" } [ "a5" ] "a6" ;\n' ..
    '} "z" ',

    '{\n' ..
    '    expr = term { plus term } .\n' ..
    '    term = factor { times factor } .\n' ..
    '    factor = number | \'(\' expr \')\' .\n' ..
    ' \n' ..
    '    plus = "+" | "-" .\n' ..
    '    times = "*" | "/" .\n' ..
    ' \n' ..
    '    number = digit { digit } .\n' ..
    '    digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" .\n' ..
    '}',

    'a = "1"',
    '{ a = "1" ;',
    '{ hello world = "1"; }',
    '{ foo = bar . }'
}

local tests = {
    {
        'a1a3a4a4a5a6',
        'a1 a2a6',
        'a1 a3 a4 a6',
        'a1 a4 a5 a6',
        'a1 a2 a4 a5 a5 a6',
        'a1 a2 a4 a5 a6 a7',
        'your ad here'
    },
    {
        '2',
        '2*3 + 4/23 - 7',
        '(3 + 4) * 6-2+(4*(4))',
        '-2',
        '3 +',
        '(4 + 3'
    }
}

for i = 1, #ebnfs do
    if parser:parse(ebnfs[i]) == 1 then
        print('\ntests:')
        if i <= #tests then
            for _, test in ipairs(tests[i]) do
                parser:checkValid(test)
            end
        end
    end
    print('')
end
