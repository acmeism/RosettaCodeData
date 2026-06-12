getch() = UInt8(ccall(:_getch, Cint, ()))
cls() = print("\33[2J")
reposition(row, col) = print("\u001b[$row;$(col)H")
clearfromcursor() = print("\u001b[K")

function input_y_x_upto(row, col, cmax, width=cmax)
    buf = ""
    while (buflen = length(buf)) < cmax && !((c = getch()) in [0xff, 0x0d, 0x0a])
        reposition(row, col)
        clearfromcursor()
        if c == '\b' && buflen > 0
            buf = buf[1:end-1]
        else
            buf = buf * Char(c)
        end
        print(buf[(buflen > width ? buflen - width + 1 : 1):end])
    end
    return buf
end

cls()
reposition(3, 5)
s = input_y_x_upto(3, 5, 80, 8)
println("\n\n\nResult:  You entered <<$s>>")
