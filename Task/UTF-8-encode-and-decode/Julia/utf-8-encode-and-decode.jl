for t in ("A", "ö", "Ж", "€", "𝄞")
    println(t, " → ", codeunits(t))
end
