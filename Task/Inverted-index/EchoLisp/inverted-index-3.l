(map-files invert-text FILES)
(inverted-search is it)
[0]→ { T0.txt T1.txt T2.txt }
(inverted-search is banana)
[1]→ { T2.txt }
(inverted-search is what)
[2]→ { T0.txt T1.txt }
(inverted-search boule)
[3]→ null
