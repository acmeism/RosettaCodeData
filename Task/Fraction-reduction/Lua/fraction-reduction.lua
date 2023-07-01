function indexOf(haystack, needle)
    for idx,straw in pairs(haystack) do
        if straw == needle then
            return idx
        end
    end

    return -1
end

function getDigits(n, le, digits)
    while n > 0 do
        local r = n % 10
        if r == 0 or indexOf(digits, r) > 0 then
            return false
        end
        le = le - 1
        digits[le + 1] = r
        n = math.floor(n / 10)
    end
    return true
end

function removeDigit(digits, le, idx)
    local pows = { 1, 10, 100, 1000, 10000 }

    local sum = 0
    local pow = pows[le - 2 + 1]
    for i = 1, le do
        if i ~= idx then
            sum = sum + digits[i] * pow
            pow = math.floor(pow / 10)
        end
    end
    return sum
end

function main()
    local lims = { {12, 97}, {123, 986}, {1234, 9875}, {12345, 98764} }
    local count = { 0, 0, 0, 0, 0 }
    local omitted = {
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    }

    for i,_ in pairs(lims) do
        local nDigits = {}
        local dDigits = {}
        for j = 1, i + 2 - 1 do
            nDigits[j] = -1
            dDigits[j] = -1
        end

        for n = lims[i][1], lims[i][2] do
            for j,_ in pairs(nDigits) do
                nDigits[j] = 0
            end
            local nOk = getDigits(n, i + 2 - 1, nDigits)
            if nOk then
                for d = n + 1, lims[i][2] + 1 do
                    for j,_ in pairs(dDigits) do
                        dDigits[j] = 0
                    end
                    local dOk = getDigits(d, i + 2 - 1, dDigits)
                    if dOk then
                        for nix,_ in pairs(nDigits) do
                            local digit = nDigits[nix]
                            local dix = indexOf(dDigits, digit)
                            if dix >= 0 then
                                local rn = removeDigit(nDigits, i + 2 - 1, nix)
                                local rd = removeDigit(dDigits, i + 2 - 1, dix)
                                if (n / d) == (rn / rd) then
                                    count[i] = count[i] + 1
                                    omitted[i][digit + 1] = omitted[i][digit + 1] + 1
                                    if count[i] <= 12 then
                                        print(string.format("%d/%d = %d/%d by omitting %d's", n, d, rn, rd, digit))
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        print()
    end

    for i = 2, 5 do
        print("There are "..count[i - 2 + 1].." "..i.."-digit fractions of which:")
        for j = 1, 9 do
            if omitted[i - 2 + 1][j + 1] > 0 then
                print(string.format("%6d have %d's omitted", omitted[i - 2 + 1][j + 1], j))
            end
        end
        print()
    end
end

main()
