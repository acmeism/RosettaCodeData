input = [
    ["pi=3.14159265358979323846264338327950288419716939937510582097494459231", " ", 5],
    [raw"The author has two Z$100000000000000 Zimbabwe notes (100 trillion).", "."],
    [raw"-in Aus$+1411.8millions"],
    [raw"===US$0017440 millions=== (in 2000 dollars)"],
    ["123.e8000 is pretty big."],
    ["The land area of the earth is  57268900(29% of the surface)  square miles."],
    ["Ain\'t no numbers in this here words, nohow, no way, Jose."],
    ["James was never known as  0000000007"],
    ["Arthur Eddington wrote: I believe there are 15747724136275002577605653961181555468044717914527116709366231425076185631031296 protons in the universe."],
    [raw"   $-140000±100  millions."],
    ["6/9/1946 was a good year for some."]]

function commatize(tst)
    grouping = (length(tst) == 3) ? tst[3] : 3
    sep = (length(tst) > 1) ? tst[2] : ","
    rmend(s) = replace(s, Regex("$sep\\Z") =>"")
    greg = Regex(".{$grouping}")
    cins(str) = reverse(rmend(replace(reverse(str), greg => s -> s * sep)))
    mat = match(Regex("(?<![eE\\/])([1-9]\\d{$grouping,})"), tst[1])
    if mat != nothing
        return replace(tst[1], mat.match => cins)
    end
    return tst[1]
end

for tst in input
    println(commatize(tst))
end
