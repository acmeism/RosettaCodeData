function pprint(expr, indent)
    local function prindent(fmt, expr)
        io.write(indent) -- no line break
        print(string.format(fmt, expr))
    end
    if type(expr) == 'table' then
        if #expr == 0 then
            prindent('()')
        else
            prindent('(')
            local indentmore = '  ' .. indent
            for i= 1,#expr do pprint(expr[i], indentmore) end
            prindent(')')
        end
    elseif type(expr) == 'string' then
        if expr:sub(1,1) == '"' then
            prindent("%q", expr:sub(2,-2)) -- print as a Lua string
        else
            prindent("%s", expr) -- print as a symbol
        end
    else
        prindent("%s", expr)
    end
end

pprint(eg_expected, '')
