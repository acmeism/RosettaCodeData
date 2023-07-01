begin
    logical procedure isPrime ( integer value n ) ; algol "isPrime" ;
    for i := 0 until 32 do if isPrime( i ) then writeon( i_w := 1,s_w := 1, i )
end.
