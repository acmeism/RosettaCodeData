a := method(bool,
    writeln("a(#{bool}) called." interpolate)
    bool
)
b := method(bool,
    writeln("b(#{bool}) called." interpolate)
    bool
)

list(true,false) foreach(avalue,
    list(true,false) foreach(bvalue,
        x := a(avalue) and b(bvalue)
        writeln("x = a(#{avalue}) and b(#{bvalue}) is #{x}" interpolate)
        writeln
        y := a(avalue) or b(bvalue)
        writeln("y = a(#{avalue}) or b(#{bvalue}) is #{y}" interpolate)
        writeln
    )
)
