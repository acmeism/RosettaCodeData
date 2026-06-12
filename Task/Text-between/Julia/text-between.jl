function textbetween(text::AbstractString, startdlm::AbstractString, enddlm::AbstractString)
    startind = startdlm != "start" ? last(search(text, startdlm)) + 1 : 1
    endind   = enddlm   != "end"   ? first(search(text, enddlm, startind)) - 1 : endof(text)
    if iszero(startind) || iszero(endind) return "" end
    return text[startind:endind]
end

testcases = [("Hello Rosetta Code world", "Hello ", " world"),
             ("Hello Rosetta Code world", "start", " world"),
             ("Hello Rosetta Code world", "Hello", "end"),
             ("</div><div style=\"chinese\">你好嗎</div>", "<div style=\"chinese\">", "</div>"),
             ("<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">", "<text>", "<table>"),
             ("<table style=\"myTable\"><tr><td>hello world</td></tr></table>", "<table>", "</table>"),
             ("The quick brown fox jumps over the lazy other fox", "quick ", " fox"),
             ("One fish two fish red fish blue fish", "fish ", " red"),
             ("FooBarBazFooBuxQuux", "Foo", "Foo")]


for (text, s, e) in testcases
    println("\nText: ", text, "\nStart delim: ", s, "\nEnd delim: ", e, "\nOutput: ", textbetween(text, s, e))
end
