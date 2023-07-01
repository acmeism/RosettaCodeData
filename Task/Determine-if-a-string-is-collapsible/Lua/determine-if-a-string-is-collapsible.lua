function collapse(s)
    local ns = ""
    local last = nil
    for c in s:gmatch"." do
        if last then
            if last ~= c then
                ns = ns .. c
            end
            last = c
        else
            ns = ns .. c
            last = c
        end
    end
    return ns
end

function test(s)
    print("old: " .. s:len() .. " <<<" .. s .. ">>>")
    local a = collapse(s)
    print("new: " .. a:len() .. " <<<" .. a .. ">>>")
end

function main()
    test("")
    test("The better the 4-wheel drive, the further you'll be from help when ya get stuck!")
    test("headmistressship")
    test("\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln ")
    test("..1111111111111111111111111111111111111111111111111111111111111117777888")
    test("I never give 'em hell, I just tell the truth, and they think it's hell. ")
    test("                                                    --- Harry S Truman  ")
end

main()
