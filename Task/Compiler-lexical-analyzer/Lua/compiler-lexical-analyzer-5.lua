-- module basic_token_finder
local M = {} -- only items added to M will be public (via 'return M' at end)
local table, string = table, string
local error, tonumber, select, assert = error, tonumber, select, assert

local token_name = require 'token_name'
_ENV = {}

function next_token(line, pos, line_num) -- match a token at line,pos
    local function m(pat)
        from, to, capture = line:find(pat, pos)
        if from then
            pos = to + 1
            return capture
        end
    end

    local function ptok(str)
        return {name=token_name[str]}
    end

    local function op2c()
        local text = m'^([<>=!]=)' or m'^(&&)' or m'^(||)'
        if text then return ptok(text) end
    end

    local function op1c_or_symbol()
        local char = m'^([%*/%%%+%-<>!=%(%){};,])'
        if char then return ptok(char) end
    end

    local function keyword_or_identifier()
        local text = m'^([%a_][%w_]*)'
        if text then
            local name = token_name[text]
            return name and {name=name} or {name='Identifier', value=text}
        end
    end

    local function integer()
        local text = m'^(%d+)%f[^%w_]'
        if text then return {name='Integer', value=tonumber(text)} end
    end

    local subst = {['\\\\'] = '\\', ['\\n'] = '\n'}

    local function qchar()
        local text = m"^'([^\\])'" or m"^'(\\[\\n])'"
        if text then
            local value = #text==1 and text:byte() or subst[text]:byte()
            return {name='Integer', value=value}
        end
    end

    local function qstr()
        local text = m'^"([^"\n]*\\?)"'
        if text then
            local value = text:gsub('()(\\.?)', function(at, esc)
                local replace = subst[esc]
                if replace then
                    return replace
                else
                    error{err='bad_escseq', line=line_num, column=pos+at-1}
                end
            end)
            return {name='String', value=value}
        end
    end

    local found = (op2c() or op1c_or_symbol() or
                   keyword_or_identifier() or integer() or qchar() or qstr())
    if found then
        return found, pos
    end
end

function find_commentrest(line, pos, line_num, socpos)
    local sfrom, sto = line:find('%*%/', pos)
    if sfrom then
        return socpos, sto
    else
        error{err='unfinished_comment', line=line_num, column=socpos}
    end
end

function find_comment(line, pos, line_num)
    local sfrom, sto = line:find('^%/%*', pos)
    if sfrom then
        local efrom, eto = find_commentrest(line, sto+1, line_num, sfrom)
        return sfrom, eto
    end
end

function find_morecomment(line, pos, line_num)
    assert(pos==1)
    return find_commentrest(line, pos, line_num, pos)
end

function find_whitespace(line, pos, line_num)
    local spos = pos
    repeat
        local eto = select(2, line:find('^%s+', pos))
        if not eto then
            eto = select(2, find_comment(line, pos, line_num))
        end
        if eto then pos = eto + 1 end
    until not eto
    return spos, pos - 1
end

function M.find_token(line, pos, line_num, in_comment)
    local spos = pos
    if in_comment then
        pos = 1 + select(2, find_morecomment(line, pos, line_num))
    end
    pos = 1 + select(2, find_whitespace(line, pos, line_num))
    if pos > #line then
        return nil
    else
        local token, nextpos = next_token(line, pos, line_num)
        if token then
            token.line, token.column = line_num, pos
            return token, nextpos
        else
            error{err='invalid_token', line=line_num, column=pos}
        end
    end
end

-- M._ENV = _ENV
return M
