function printverse(name::AbstractString)
    X = uppercasefirst(lowercase(name))
    Y = X[1] ∈ ('A', 'E', 'I', 'O', 'U') ? X : SubString(X, 2)
    b = X[1] == 'B' ? "" : "b"
    f = X[1] == 'F' ? "" : "f"
    m = X[1] == 'M' ? "" : "m"
    println("""\
    $(X), $(X), bo-$b$(Y)
    Banana-fana fo-$f$(Y)
    Fee-fi-mo-$m$(Y)
    $(X)!
    """)
    return nothing
end

foreach(printverse, ("gARY", "Earl", "Billy", "Felix", "Mary", "sHIRley"))
