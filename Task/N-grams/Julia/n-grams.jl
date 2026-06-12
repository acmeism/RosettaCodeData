function ngrams(str::AbstractString, n; uppercaseinput = true)
    s = uppercaseinput ? uppercase(str) : str
    unique([(ng, count(ng, s)) for ng in [SubString(s, i:i+n-1) for i=1:length(s)-n+1]])
end

function eightcolumns(arr)
    for (i, elem) in pairs(arr)
        print(lpad(elem, 10), i % 8 == 0 ? "\n" : "")
    end
    println("\n")
end

const s = "Live and let live"

ngrams(s, 1) |> eightcolumns
ngrams(s, 2) |> eightcolumns
ngrams(s, 2, uppercaseinput = false) |> eightcolumns
