BEGIN # calculate the Golden Ratio and show the number of iterations required #

  INT  count := 0;
  REAL phi0  := 1, diff := 1e20;

  WHILE 1e-5 < diff DO
      REAL phi1 = 1.0 + ( 1.0 / phi0 );
      diff     := ABS ( phi1 - phi0 );
      phi0     := phi1;
      count   +:= 1
  OD;

  print( ( "Result:", fixed( phi0, -9, 6 ), " after ", whole( count, 0 ), " iterations", newline ) );
  print( ( "The error is approximately ", fixed( phi0 - ( 0.5 * ( 1 + sqrt( 5 ) ) ), -9, 6 ), newline ) )

END
