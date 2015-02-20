xor_pattern :-
	new(D, window('XOR Pattern')),
	send(D, size, size(512,512)),
	new(Img, image(@nil, width := 512, height := 512 , kind := pixmap)),

	forall(between(0,511, I),
	       (   forall(between(0,511, J),
			  (   V is I xor J,
			      R is (V * 1024) mod 65536,
			      G is (65536 - V * 1024) mod 65536,
			      (	  V mod 2 =:= 0
			      ->  B is  (V * 4096) mod 65536
			      ;	   B is  (65536 - (V * 4096)) mod 65536),
			      send(Img, pixel(I, J, colour(@default, R, G, B))))))),

	new(Bmp, bitmap(Img)),
	send(D, display, Bmp, point(0,0)),
	send(D, open).
