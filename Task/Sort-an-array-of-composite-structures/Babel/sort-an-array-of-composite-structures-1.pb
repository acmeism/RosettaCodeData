babel> baz ([map "foo" 3 "bar" 17] [map "foo" 4 "bar" 18] [map "foo" 5 "bar" 19] [map "foo" 0 "bar" 20]) <
babel> bop baz { <- "foo" lumap ! -> "foo" lumap ! lt? } lssort ! <
babel> bop {"foo" lumap !} over ! lsnum !
( 0 3 4 5 )
