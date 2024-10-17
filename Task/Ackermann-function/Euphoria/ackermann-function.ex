function ack(atom m, atom n)
    if m = 0 then
        return n + 1
    elsif m > 0 and n = 0 then
        return ack(m - 1, 1)
    else
        return ack(m - 1, ack(m, n - 1))
    end if
end function

for i = 0 to 3 do
    for j = 0 to 6 do
        printf( 1, "%5d", ack( i, j ) )
    end for
    puts( 1, "\n" )
end for
