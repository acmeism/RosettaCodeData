function make(value, modulo)
    local v = value % modulo
    local tbl = {value=v, modulo=modulo}

    local mt = {
        __add = function(lhs, rhs)
            if type(lhs) == "table" then
                if type(rhs) == "table" then
                    if lhs.modulo ~= rhs.modulo then
                        error("Cannot add rings with different modulus")
                    end
                    return make(lhs.value + rhs.value, lhs.modulo)
                else
                    return make(lhs.value + rhs, lhs.modulo)
                end
            else
                error("lhs is not a table in +")
            end
        end,
        __mul = function(lhs, rhs)
            if lhs.modulo ~= rhs.modulo then
                error("Cannot multiply rings with different modulus")
            end
            return make(lhs.value * rhs.value, lhs.modulo)
        end,
        __pow = function(b,p)
            if p<0 then
                error("p must be zero or greater")
            end

            local pp = p
            local pwr = make(1, b.modulo)
            while pp > 0 do
                pp = pp - 1
                pwr = pwr * b
            end
            return pwr
        end,
        __concat = function(lhs, rhs)
            if type(lhs) == "table" and type(rhs) == "string" then
                return "ModInt("..lhs.value..", "..lhs.modulo..")"..rhs
            elseif type(lhs) == "string" and type(rhs) == "table" then
                return lhs.."ModInt("..rhs.value..", "..rhs.modulo..")"
            else
                return "todo"
            end
        end
    }

    setmetatable(tbl, mt)
    return tbl
end

function func(x)
    return x ^ 100 + x + 1
end

-- main
local x = make(10, 13)
local y = func(x)
print("x ^ 100 + x + 1 for "..x.." is "..y)
