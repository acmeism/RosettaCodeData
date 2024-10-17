arr(s) = [c for c in s]
alldup(a) = filter(x -> length(x) > 1, [findall(x -> x == a[i], a) for i in 1:length(a)])
firstduplicate(s) = (a = arr(s); d = alldup(a); isempty(d) ? nothing : first(d))

function testfunction(strings)
    println("String                            | Length | All Unique | First Duplicate | Positions\n" *
            "-------------------------------------------------------------------------------------")
    for s in strings
        n = firstduplicate(s)
        a = arr(s)
        println(rpad(s, 38), rpad(length(s), 11), n == nothing ? "yes" :
                rpad("no               $(a[n[1]])", 26) * rpad(n[1], 4) * "$(n[2])")
    end
end

testfunction([
"",
".",
"abcABC",
"XYZ ZYX",
"1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ",
 "hétérogénéité",
"🎆🎃🎇🎈",
"😍😀🙌💃😍🙌",
"🐠🐟🐡🦈🐬🐳🐋🐡",
])
