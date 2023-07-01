function tprint(tbl)
    for i,v in pairs(tbl) do
        print(v)
    end
end

function deBruijn(k, n)
    local a = {}
    for i=1, k*n do
        table.insert(a, 0)
    end

    local seq = {}
    function db(t, p)
        if t > n then
            if n % p == 0 then
                for i=1, p do
                    table.insert(seq, a[i + 1])
                end
            end
        else
            a[t + 1] = a[t - p + 1]
            db(t + 1, p)

            local j = a[t - p + 1] + 1
            while j < k do
                a[t + 1] = j % 256
                db(t + 1, t)
                j = j + 1
            end
        end
    end

    db(1, 1)

    local buf = ""
    for i,v in pairs(seq) do
        buf = buf .. tostring(v)
    end
    return buf .. buf:sub(1, n - 1)
end

function allDigits(s)
    return s:match('[0-9]+') == s
end

function validate(db)
    local le = string.len(db)
    local found = {}
    local errs = {}

    for i=1, 10000 do
        table.insert(found, 0)
    end

    -- Check all strings of 4 consecutive digits within 'db'
    -- to see if all 10,000 combinations occur without duplication.
    for i=1, le - 3 do
        local s = db:sub(i, i + 3)
        if allDigits(s) then
            local n = tonumber(s)
            found[n + 1] = found[n + 1] + 1
        end
    end

    local count = 0
    for i=1, 10000 do
        if found[i] == 0 then
            table.insert(errs, "    PIN number " .. (i - 1) .. " missing")
            count = count + 1
        elseif found[i] > 1 then
            table.insert(errs, "    PIN number " .. (i - 1) .. " occurs " .. found[i] .. " times")
            count = count + 1
        end
    end

    if count == 0 then
        print("  No errors found")
    else
        tprint(errs)
    end
end

function main()
    local db = deBruijn(10,4)

    print("The length of the de Bruijn sequence is " .. string.len(db))
    print()

    io.write("The first 130 digits of the de Bruijn sequence are: ")
    print(db:sub(0, 130))
    print()

    io.write("The last 130 digits of the de Bruijn sequence are: ")
    print(db:sub(-130))
    print()

    print("Validating the de Bruijn sequence:")
    validate(db)
    print()

    print("Validating the reversed de Bruijn sequence:")
    validate(db:reverse())
    print()

    db = db:sub(1,4443) .. "." .. db:sub(4445)
    print("Validating the overlaid de Bruijn sequence:")
    validate(db)
    print()
end

main()
