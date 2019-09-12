  int i = 0 ;  char B[88] ;
  while ( i++ < 100 )
    !sprintf( B, "%s%s%s%s",
       i%3 ? "":"Fiz", i%5 ? "":"Buz", i%7 ? "":"Goz", i%11 ? "":"Kaz" )
    ? sprintf( B, "%d", i ):0, printf( ", %s", B );
