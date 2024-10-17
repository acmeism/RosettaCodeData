s = "niño"
println("Position  Char Bytes\n==============================")
for (i, c) in enumerate(s)
    println("$i          $c     $(sizeof(c))")
end
