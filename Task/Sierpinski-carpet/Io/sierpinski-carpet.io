sierpinskiCarpet := method(n,
    carpet := list("@")
    n repeat(
        next := list()
        carpet foreach(s, next append(s .. s .. s))
        carpet foreach(s, next append(s .. (s asMutable replaceSeq("@"," ")) .. s))
        carpet foreach(s, next append(s .. s .. s))
        carpet = next
    )
    carpet join("\n")
)

sierpinskiCarpet(3) println
