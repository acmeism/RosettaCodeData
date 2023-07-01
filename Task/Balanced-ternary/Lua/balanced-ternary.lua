function to_bt(n)
    local d = { '0', '+', '-' }
    local v = { 0, 1, -1 }

    local b = ""

    while n ~= 0 do
        local r = n % 3
        if r < 0 then
            r = r + 3
        end

        b = b .. d[r + 1]

        n = n - v[r + 1]
        n = math.floor(n / 3)
    end

    return b:reverse()
end

function from_bt(s)
    local n = 0

    for i=1,s:len() do
        local c = s:sub(i,i)
        n = n * 3
        if c == '+' then
            n = n + 1
        elseif c == '-' then
            n = n - 1
        end
    end

    return n
end

function last_char(s)
    return s:sub(-1,-1)
end

function add(b1,b2)
    local out = "oops"
    if b1 ~= "" and b2 ~= "" then
        local d = ""

        local L1 = last_char(b1)
        local c1 = b1:sub(1,-2)
        local L2 = last_char(b2)
        local c2 = b2:sub(1,-2)
        if L2 < L1 then
            L2, L1 = L1, L2
        end

        if L1 == '-' then
            if L2 == '0' then
                d = "-"
            end
            if L2 == '-' then
                d = "+-"
            end
        elseif L1 == '+' then
            if L2 == '0' then
                d = "+"
            elseif L2 == '-' then
                d = "0"
            elseif L2 == '+' then
                d = "-+"
            end
        elseif L1 == '0' then
            if L2 == '0' then
                d = "0"
            end
        end

        local ob1 = add(c1,d:sub(2,2))
        local ob2 = add(ob1,c2)

        out = ob2 .. d:sub(1,1)
    elseif b1 ~= "" then
        out = b1
    elseif b2 ~= "" then
        out = b2
    else
        out = ""
    end

    return out
end

function unary_minus(b)
    local out = ""

    for i=1, b:len() do
        local c = b:sub(i,i)
        if c == '-' then
            out = out .. '+'
        elseif c == '+' then
            out = out .. '-'
        else
            out = out .. c
        end
    end

    return out
end

function subtract(b1,b2)
    return add(b1, unary_minus(b2))
end

function mult(b1,b2)
    local r = "0"
    local c1 = b1
    local c2 = b2:reverse()

    for i=1,c2:len() do
        local c = c2:sub(i,i)
        if c == '+' then
            r = add(r, c1)
        elseif c == '-' then
            r = subtract(r, c1)
        end
        c1 = c1 .. '0'
    end

    while r:sub(1,1) == '0' do
        r = r:sub(2)
    end

    return r
end

function main()
    local a = "+-0++0+"
    local b = to_bt(-436)
    local c = "+-++-"
    local d = mult(a, subtract(b, c))

    print(string.format("      a: %14s %10d", a, from_bt(a)))
    print(string.format("      b: %14s %10d", b, from_bt(b)))
    print(string.format("      c: %14s %10d", c, from_bt(c)))
    print(string.format("a*(b-c): %14s %10d", d, from_bt(d)))
end

main()
