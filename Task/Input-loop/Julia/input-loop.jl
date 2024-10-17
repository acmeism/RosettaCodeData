stream = IOBuffer("1\n2\n3\n4\n\n6")

while !eof(stream)
    line = readline(stream)
    println(line)
end
