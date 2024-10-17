procedure triangle(integer x, integer y, integer len, integer n)
    if n = 0 then
        position(y,x) puts(1,'*')
    else
        triangle (x,       y+len, floor(len/2), n-1)
        triangle (x+len,   y,     floor(len/2), n-1)
        triangle (x+len*2, y+len, floor(len/2), n-1)
    end if
end procedure

clear_screen()
triangle(1,1,8,4)
