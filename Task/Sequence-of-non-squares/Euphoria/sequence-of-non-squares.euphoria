function nonsqr( atom n)
    return n + floor( 0.5 + sqrt( n ) )
end function

puts( 1, "  n  r(n)\n" )
puts( 1, "---  ---\n" )
for i = 1 to 22 do
    printf( 1, "%3d  %3d\n", { i, nonsqr(i) } )
end for

atom j
atom found
found = 0
for i = 1 to 1000000 do
    j = sqrt(nonsqr(i))
    if integer(j) then
        found = 1
        printf( 1, "Found square: %d\n", i )
        exit
    end if
end for
if found = 0 then
    puts( 1, "No squares found\n" )
end if
