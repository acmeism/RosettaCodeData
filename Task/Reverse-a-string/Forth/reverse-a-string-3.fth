: xreverse {: c-addr u -- c-addr2 u :}
    u allocate throw u + c-addr swap over u + >r begin ( from to r:end)
	over r@ u< while
	    over r@ over - x-size dup >r - 2dup r@ cmove
	    swap r> + swap repeat
    r> drop nip u ;

\ example use
s" ώщыē" xreverse type \ outputs "ēыщώ"
