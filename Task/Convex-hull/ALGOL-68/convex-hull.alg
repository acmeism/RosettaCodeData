BEGIN # Convex hull - translation of the EasyLang sample #

   PROC orientation = ( []INT p, q, r )INT: (q[2] - p[2]) * (r[1] - q[1]) - (q[1] - p[1]) * (r[2] - q[2]);

   PROC convexhull = ( [,]INT pts )[,]INT: BEGIN
      INT min pos := 1 LWB pts;
      FOR i FROM 1 LWB pts TO 1 UPB pts DO
         IF pts[ i, 2 LWB pts ] < pts[ min pos, 2 LWB pts] THEN min pos := i FI
      OD;
      INT p := min pos;
      [ 1 LWB pts : 1 UPB pts, 2 LWB pts : 2 UPB pts ]INT hull;
      FOR i FROM 1 LWB hull TO 1 UPB hull DO FOR j FROM 2 LWB hull TO 2 UPB hull DO hull[ i, j ] := 0 OD OD;
      INT hpos := 1 LWB pts - 1;
      WHILE
         hull[ hpos +:= 1, : ] := pts[ p, : ];
         INT q := ( p + 1 ) MOD 1 UPB pts;
         FOR i FROM 1 LWB pts TO 1 UPB pts DO
            IF orientation( pts[ p, : ], pts[ i, : ], pts[ q, : ] ) < 0 THEN q := i FI
         OD;
         p := q;
         p /= min pos
      DO SKIP OD;
      hull[ 1 LWB hull : hpos, : ]
   END;

   BEGIN
       [,]INT pts  = ( ( 16,  3 ), ( 12, 17 ), (  0,  6 ), ( -4, -6 ), ( 16,  6 )
                     , ( 16, -7 ), ( 16, -3 ), ( 17, -4 ), (  5, 19 ), ( 19, -8 )
                     , (  3, 16 ), ( 12, 13 ), (  3, -4 ), ( 17,  5 ), ( -3, 15 )
                     , ( -3, -9 ), (  0, 11 ), ( -9, -3 ), ( -4, -2 ), ( 12, 10 )
                     );
       [,]INT hull = convex hull( pts );
       print( ( "[" ) );
       FOR i FROM 1 LWB hull TO 1 UPB hull DO
           print( ( " [" ) );
           FOR j FROM 2 LWB hull TO 2 UPB hull DO print( ( " ", whole( hull[ i, j ], 0 ) ) ) OD;
           print( ( " ]" ) )
       OD;
       print( ( " ]", newline ) )
   END
END
