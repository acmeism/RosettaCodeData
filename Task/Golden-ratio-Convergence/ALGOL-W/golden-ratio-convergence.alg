begin % calculate the Golden Ratio and show the number of iterations required %

  integer count;
  real    phi0, diff;

  count := 0;
  phi0  := 1;
  diff  := 1'20;

  while 1'-5 < diff do begin
      real phi1;
      phi1  := 1.0 + ( 1.0 / phi0 );
      diff  := abs( phi1 - phi0 );
      phi0  := phi1;
      count := count + 1
  end while_1e_5_lt_diff ;

  write( i_w := 1, s_w := 0, "Result:", phi0, " after ", count, " iterations" );
  write( i_w := 1, s_w := 0, "The error is approximately ", phi0 - ( 0.5 * ( 1 + sqrt( 5 ) ) ) )

end.
