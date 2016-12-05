NotFound := Exception clone
List firstIndex := method(obj,
    indexOf(obj) ifNil(NotFound raise)
)
List lastIndex := method(obj,
    reverseForeach(i,v,
        if(v == obj, return i)
    )
    NotFound raise
)

haystack := list("Zig","Zag","Wally","Ronald","Bush","Krusty","Charlie","Bush","Bozo")
list("Washington","Bush") foreach(needle,
    try(
        write("firstIndex(\"",needle,"\"): ")
        writeln(haystack firstIndex(needle))
    )catch(NotFound,
        writeln(needle," is not in haystack")
    )pass
    try(
        write("lastIndex(\"",needle,"\"): ")
        writeln(haystack lastIndex(needle))
    )catch(NotFound,
        writeln(needle," is not in haystack")
    )pass
)
