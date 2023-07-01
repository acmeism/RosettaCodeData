-- Taken from https://www.rosettacode.org/wiki/Sum_and_product_of_an_array#Lua
function prodf(a, ...) return a and a * prodf(...) or 1 end
function prodt(t) return prodf(unpack(t)) end

function mulInv(a, b)
    local b0 = b
    local x0 = 0
    local x1 = 1

    if b == 1 then
        return 1
    end

    while a > 1 do
        local q = math.floor(a / b)
        local amb = math.fmod(a, b)
        a = b
        b = amb
        local xqx = x1 - q * x0
        x1 = x0
        x0 = xqx
    end

    if x1 < 0 then
        x1 = x1 + b0
    end

    return x1
end

function chineseRemainder(n, a)
    local prod = prodt(n)

    local p
    local sm = 0
    for i=1,#n do
        p = prod / n[i]
        sm = sm + a[i] * mulInv(p, n[i]) * p
    end

    return math.fmod(sm, prod)
end

n = {3, 5, 7}
a = {2, 3, 2}
io.write(chineseRemainder(n, a))
