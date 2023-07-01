for i = 1, 10 do
    io.write( i )
    if i % 5 == 0 then
        io.write( "\n" )
        goto continue
    end
    io.write( ", " )
    ::continue::
end
