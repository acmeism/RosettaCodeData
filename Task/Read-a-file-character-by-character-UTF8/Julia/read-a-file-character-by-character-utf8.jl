open("myfilename") do f
    while !eof(f)
        c = read(f, Char)
        println(c)
    end
end
