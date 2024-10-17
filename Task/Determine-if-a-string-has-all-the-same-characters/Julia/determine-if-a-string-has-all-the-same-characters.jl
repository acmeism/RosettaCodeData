firstdifferent(s) = isempty(s) ? nothing : findfirst(x -> x != s[1], s)

function testfunction(strings)
   println("String                  | Length | All Same | First Different(Hex) | Position\n" *
           "-----------------------------------------------------------------------------")
    for s in strings
        n = firstdifferent(s)
        println(rpad(s, 27), rpad(length(s), 9), n == nothing ? "yes" :
            rpad("no               $(s[n])   ($(string(Int(s[n]), base=16)))", 36) * string(n))
    end
end

testfunction([
	"",
	"   ",
	"2",
	"333",
    ".55",
    "tttTTT",
    "4444 444k",
    "pépé",
    "🐶🐶🐺🐶",
    "🎄🎄🎄🎄",
])
