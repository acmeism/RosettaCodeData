function checkIsbn13(isbn)
    local count = 0
    local sum = 0
    for c in isbn:gmatch"." do
        if c == ' ' or c == '-' then
            -- skip
        elseif c < '0' or '9' < c then
            return false
        else
            local digit = c - '0'
            if (count % 2) > 0 then
                sum = sum + 3 * digit
            else
                sum = sum + digit
            end
            count = count + 1
        end
    end

    if count ~= 13 then
        return false
    end
    return (sum % 10) == 0
end

function test(isbn)
    if checkIsbn13(isbn) then
        print(isbn .. ": good")
    else
        print(isbn .. ": bad")
    end
end

function main()
    test("978-1734314502")
    test("978-1734314509")
    test("978-1788399081")
    test("978-1788399083")
end

main()
