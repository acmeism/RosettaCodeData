-- module lpeg_token_finder
local M = {} -- only items added to M will be public (via 'return M' at end)
local table, concat = table, table.concat
local error, tonumber = error, tonumber

local lpeg = require 'lpeg' -- see http://www.inf.puc-rio.br/~roberto/lpeg/
local token_name = require 'token_name'
_ENV = {}

local imports = 'P R S C Carg Cb Cc Cf Cg Cp Cs Ct Cmt V'
for w in imports:gmatch('%a+') do _ENV[w] = lpeg[w] end

------------------- Define patterns to match tokens -----------------------

alpha = R'az' + R'AZ' + P'_'
digit = R'09'
alnum = alpha + digit
space = S' \t\r\n'

function ptok(text) return {name=token_name[text]} end
op2c = C(P'<=' + P'>=' + P'==' + P'!=' + P'&&' + P'||') / ptok
op1c = C(S'*/%+-<>!=') / ptok
symbol = C(S'(){};,') / ptok

keyword_or_identifier = C(alpha * alnum^0) / function(text)
    local name = token_name[text]
    return name and {name=name} or {name='Identifier', value=text}
end

integer = C(digit^1) * -alpha  / function(text)
    return {name='Integer', value=tonumber(text)}
end

Cline = Carg(1) -- call to 'match' sets the first extra argument to source line number

bad_escseq_err = Cmt(Cline, function (_,pos,line)
    error{err='bad_escseq', line=line, column=pos-1}
end)

esc_subst = {['\\'] = '\\', ['n'] = '\n'}
escseq = P'\\' * C(S'\\n' + bad_escseq_err) / esc_subst

qchar = P"'" * ( C( P(1) - S"'\n\\"   ) + escseq )   * P"'" / function (text)
    return {name='Integer', value=text:byte()}
end

qstr =  P'"' * ( C((P(1) - S'"\n\\')^1) + escseq )^0 * P'"' / function(...)
    return {name='String', value=concat{...}}
end

Ctoken = symbol + op2c + op1c + keyword_or_identifier + integer + qstr + qchar

unfinished_comment_err = Cmt(Cline * Cb('SOC'), function (_, pos, line, socpos)
    error{err='unfinished_comment', line=line, column=socpos}
end)
commentstart = Cg(Cp() * P'/*', 'SOC')
commentrest  =  (P(1) - P'*/')^0 * (P'*/' + unfinished_comment_err)
comment      = commentstart * commentrest
morecomment  = Cg(Cp(), 'SOC') * commentrest

ws = (space^1 + comment)^0

bad_token_err = Cmt(Cline, function (_, pos, line)
    error{err='invalid_token', line=line, column=pos}
end)

tokenpat = ws * Cline * Cp() * (C(-1) + Ctoken + bad_token_err) * Cp() /
    function (line, pos, token, nextpos)
        if pos == nextpos then -- at end of line; no token
            return nil
        else
            token.line, token.column = line, pos
            return token, nextpos
        end
    end

closecomment_tokenpat = morecomment * tokenpat

function M.find_token(line, line_pos, line_number, in_comment)
    pattern = in_comment and closecomment_tokenpat or tokenpat
    return lpeg.match(pattern, line, line_pos, line_number)
end

return M
