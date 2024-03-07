BEGIN # draw a "Death Star" - translated from the C and 11l samples #
    STRING shades = ".:!*oe&#%@";

    PROC normalize = ( []REAL v )[]REAL:
         BEGIN
            REAL len = sqrt( v[ 1 ] * v[ 1 ] + v[ 2 ] * v[ 2 ] + v[ 3 ] * v[ 3 ] );
            ( v[ 1 ] / len, v[ 2 ] / len, v[ 3 ] / len )
         END # normalize # ;

    PROC dot = ( []REAL x, y )REAL:
         BEGIN
            REAL d = x[ 1 ] * y[ 1 ] + x[ 2 ] * y[ 2 ] + x[ 3 ] * y[ 3 ];
            IF d < 0 THEN - d ELSE 0 FI
         END # dot # ;

    MODE SPHERE = STRUCT( REAL cx, cy, cz, r );

    # positive shpere and negative sphere #
    SPHERE pos = ( 20, 20, 0, 20 ), neg = ( 1, 1, -6, 20 );

    # check if a ray (x,y, -inf)->(x, y, inf) hits a sphere; if so, return #
    # the intersecting z values.  z1 is closer to the eye                  #
    PROC hit_sphere = ( SPHERE sph, REAL x in, y in, REF REAL z1, z2 )BOOL:
         IF   REAL x    = x in - cx OF sph;
              REAL y    = y in - cy OF sph;
              REAL zsq := r OF sph * r OF sph - ( x * x + y * y );
              zsq < 0
         THEN FALSE
         ELSE zsq := sqrt( zsq );
              z1  := cz OF sph - zsq;
              z2  := cz OF sph + zsq;
              TRUE
         FI # hit_sphere # ;

    PROC draw_sphere = ( REAL k, ambient, []REAL light )VOID:
         FOR i FROM ENTIER ( cy OF pos - r OF pos ) TO ENTIER ( cy OF pos + r OF pos ) + 1 DO
             REAL y := i + 0.5;
             FOR j FROM ENTIER ( cx OF pos - 2 * r OF pos ) TO ENTIER (cx OF pos + 2 * r OF pos ) + 1 DO
                 REAL x := ( j - cx OF pos ) / 2.0 + 0.5 + cx OF pos;
                 REAL zb1 := 0, zb2 := 0, zs1 := 0, zs2 := 0;
                 INT hit_result
                         = IF   NOT hit_sphere( pos, x, y, zb1, zb2 ) THEN
                               0   # ray lands in blank space, draw bg #
                           ELIF NOT hit_sphere( neg, x, y,  zs1,  zs2 ) THEN
                               1   # ray hits pos sphere but not neg, draw pos sphere surface #
                           ELIF zs1 > zb1 THEN
                               1   # ray hits both, but pos front surface is closer #
                           ELIF zs2 > zb2 THEN
                               0   # pos sphere surface is inside neg sphere, show bg #
                           ELIF zs2 > zb1 THEN
                               2   # back surface on neg sphere is inside pos sphere,      #
                                   # the only place where neg sphere surface will be shown #
                           ELSE
                               1   # show the pos sphere #
                           FI;
                 IF hit_result = 0 THEN
                     print( ( " " ) )
                 ELSE
                     []REAL vec =
                         normalize( IF hit_result = 1
                                    THEN []REAL( x   - cx OF pos
                                               , y   - cy OF pos
                                               , zb1 - cz OF pos
                                               )
                                    ELSE []REAL( cx OF neg - x
                                               , cy OF neg - y
                                               , cz OF neg - zs2
                                               )
                                    FI
                                  );
                     REAL b          = ( dot( light, vec ) ^ k ) + ambient;
                     INT  intensity := ENTIER ( ( 1 - b ) * ( ( UPB shades - LWB shades ) + 1 ) ) + 1;
                     IF   intensity < LWB shades THEN intensity := LWB shades
                     ELIF intensity > UPB shades THEN intensity := UPB shades
                     FI;
                     print( ( shades[ intensity ] ) )
                 FI
             OD;
             print( ( newline ) )
         OD # draw_sphere # ;

    BEGIN
        []REAL light = ( -50, 30, 50 );
        draw_sphere( 2, 0.5, normalize( light ) )
    END
END
