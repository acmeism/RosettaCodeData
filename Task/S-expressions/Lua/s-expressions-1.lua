lpeg = require 'lpeg' -- see http://www.inf.puc-rio.br/~roberto/lpeg/

imports = 'P R S C V match'
for w in imports:gmatch('%a+') do _G[w] = lpeg[w] end -- make e.g. 'lpeg.P' function available as 'P'

function tosymbol(s) return s end
function tolist(x, ...) return {...} end -- ignore the first capture, the whole sexpr

ws = S' \t\n'^0                 -- whitespace, 0 or more

digits = R'09'^1                -- digits, 1 or more
Tnumber = C(digits * (P'.' * digits)^-1) * ws / tonumber -- ^-1 => at most 1

Tstring = C(P'"' * (P(1) - P'"')^0 * P'"') * ws

sep = S'()" \t\n'
symstart = (P(1) - (R'09' + sep))
symchar = (P(1) - sep)
Tsymbol = C(symstart * symchar^0) * ws / tosymbol

atom = Tnumber + Tstring + Tsymbol
lpar = P'(' * ws
rpar = P')' * ws
sexpr = P{ -- defines a recursive pattern
    'S';
    S = ws * lpar * C((atom + V'S')^0) * rpar / tolist
}
