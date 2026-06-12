USING: math math.functions prettyprint ;

: least-sq ( m -- n ) 2 / 1 + ceiling ;

1000 least-sq .
