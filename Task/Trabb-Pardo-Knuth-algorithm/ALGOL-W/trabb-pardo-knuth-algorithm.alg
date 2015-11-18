begin
  real y; real array a( 0 :: 10 );
  real procedure f( real value t );
    sqrt(abs(t))+5*t*t*t;
  for i:=0 until 10 do read( a(i) );
  r_format := "A"; r_w := 9; r_d := 4;
  for i:=10 step -1 until 0 do
    begin
       y:=f(a(i));
       if y > 400 then write( "TOO LARGE" )
                  else write( y );
    end
end.
