function analyze(s)
    print(string.format("Examining [%s] which has a length of %d:", s, string.len(s)))
    if string.len(s) > 1 then
        local last = string.byte(string.sub(s,1,1))
        for i=1,string.len(s) do
            local c = string.byte(string.sub(s,i,i))
            if last ~= c then
                print("    Not all characters in the string are the same.")
                print(string.format("    '%s' (0x%x) is different at position %d", string.sub(s,i,i), c, i - 1))
                return
            end
        end
    end
    print("    All characters in the string are the same.")
end

function main()
    analyze("")
    analyze("   ")
    analyze("2")
    analyze("333")
    analyze(".55")
    analyze("tttTTT")
    analyze("4444 444k")
end

main()
