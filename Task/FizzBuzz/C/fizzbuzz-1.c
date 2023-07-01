  int i = 0 ;  char B[88] ;
  while ( i++ < 100 )
    !sprintf( B, "%s%s", i%3 ? "":"Fizz", i%5 ? "":"Buzz" )
    ? sprintf( B, "%d", i ):0, printf( ", %s", B );
