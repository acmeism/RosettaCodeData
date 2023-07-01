begin
   integer procedure ackermann( integer value m,n ) ;
       if m=0 then n+1
       else if n=0 then ackermann(m-1,1)
                   else ackermann(m-1,ackermann(m,n-1));
   for m := 0 until 3 do begin
      write( ackermann( m, 0 ) );
      for n := 1 until 6 do writeon( ackermann( m, n ) );
   end for_m
end.
