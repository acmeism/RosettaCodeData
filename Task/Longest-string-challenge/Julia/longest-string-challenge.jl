function longer(a, b)
    try
        b[endof(a)]
    catch
        return true
    end
    return false
end

function printlongest(io::IO)
    lines = longest = ""
    while !eof(io)
        line = readline(io)
        if longer(line, longest)
            longest = lines = line
        elseif !longer(longest, line)
            lines *= "\n" * line
        end
    end
    println(lines)
end
printlongest(str::String) = printlongest(IOBuffer(str))

printlongest("a\nbb\nccc\nddd\nee\nf\nggg")
