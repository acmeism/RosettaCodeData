println("Position  Codeunit Bytes\n==============================")
for (i, c) in enumerate(codeunits(s))
    println("$i            $(string(c, base=16))     $(sizeof(c))")
end
