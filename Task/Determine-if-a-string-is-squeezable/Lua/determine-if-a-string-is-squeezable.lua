function squeezable(s, rune)
    print("squeeze: `" .. rune .. "`")
    print("old: <<<" .. s .. ">>>, length = " .. string.len(s))

    local last = nil
    local le = 0
    io.write("new: <<<")
    for c in s:gmatch"." do
        if c ~= last or c ~= rune then
            io.write(c)
            le = le + 1
        end
        last = c
    end
    print(">>>, length = " .. le)

    print()
end

function main()
    squeezable("", ' ');
    squeezable("\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln ", '-')
    squeezable("..1111111111111111111111111111111111111111111111111111111111111117777888", '7')
    squeezable("I never give 'em hell, I just tell the truth, and they think it's hell. ", '.')

    local s = "                                                    --- Harry S Truman  "
    squeezable(s, ' ')
    squeezable(s, '-')
    squeezable(s, 'r')
end

main()
