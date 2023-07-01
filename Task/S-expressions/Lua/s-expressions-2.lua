eg_input = [[
((data "quoted data" 123 4.5)
 (data (!@# (4.5) "(more" "data)")))
]]

eg_produced = match(sexpr, eg_input)

eg_expected = { -- expected Lua data structure of the reader (lpeg.match)
    {'data', '"quoted data"', 123, 4.5},
    {'data', {'!@#', {4.5}, '"(more"', '"data)"'}}
}

function check(produced, expected)
    assert(type(produced) == type(expected))
    if type(expected) == 'table' then -- i.e. a list
        assert(#produced == #expected)
        for i = 1, #expected do check(produced[i], expected[i]) end
    else
        assert(produced == expected)
    end
end

check(eg_produced, eg_expected)
print("checks out!") -- won't get here if any <i>check()</i> assertion fails
