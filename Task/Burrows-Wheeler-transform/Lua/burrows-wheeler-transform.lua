STX = string.char(tonumber(2,16))
ETX = string.char(tonumber(3,16))

function bwt(s)
    if s:find(STX, 1, true) then
        error("String cannot contain STX")
    end
    if s:find(ETX, 1, true) then
        error("String cannot contain ETX")
    end

    local ss = STX .. s .. ETX
    local tbl = {}
    for i=1,#ss do
        local before = ss:sub(i + 1)
        local after = ss:sub(1, i)
        table.insert(tbl, before .. after)
    end

    table.sort(tbl)

    local sb = ""
    for _,v in pairs(tbl) do
        sb = sb .. string.sub(v, #v, #v)
    end

    return sb
end

function ibwt(r)
    local le = #r
    local tbl = {}

    for i=1,le do
        table.insert(tbl, "")
    end
    for j=1,le do
        for i=1,le do
            tbl[i] = r:sub(i,i) .. tbl[i]
        end
        table.sort(tbl)
    end

    for _,row in pairs(tbl) do
        if row:sub(le,le) == ETX then
            return row:sub(2, le - 1)
        end
    end

    return ""
end

function makePrintable(s)
    local a = s:gsub(STX, '^')
    local b = a:gsub(ETX, '|')
    return b
end

function main()
    local tests = {
        "banana",
        "appellee",
        "dogwood",
        "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
        "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
        STX .. "ABC" .. ETX
    }

    for _,test in pairs(tests) do
        print(makePrintable(test))
        io.write(" --> ")
        local t = ""
        if xpcall(
            function () t = bwt(test) end,
            function (err) print("ERROR: " .. err) end
        ) then
            print(makePrintable(t))
        end
        local r = ibwt(t)
        print(" --> " .. r)
        print()
    end
end

main()
