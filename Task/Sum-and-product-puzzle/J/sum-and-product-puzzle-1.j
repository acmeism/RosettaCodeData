(S=. X + Y) (P=. X * Y) (X=. 0&{"1) (Y=. 1&{"1)
(sd=. S </. ]) (pd=. P </. ])       NB. sum and product decompositions

candidates=. ([ echo o (' candidates' ,~ ": (o=. @:) #))
constraints=. (([ >: S o ]) and ((1 < X) and (1 < Y) (and=. *.) (X < Y)) o ])
filter0=. candidates o (constraints # ])

patesd=. S (< o P)/. ]              NB. products associated to each sum decomposition
pmtod=. P o ; o (pd #~ 1 < P #/. ]) NB. products with more than one decomposition
filter1=. candidates o ((patesd ('' -: -.)&>"0 _ < o pmtod) ; o # sd)

filter2=. candidates o ; o (pd #~ 1 = (#&>) o pd)
filter3=. candidates o ; o (sd #~ 1 = (#&>) o sd)

decompositions=. > o , o { o (;~) o i.
show=. 'X=' , ": o X ,' Y=' , ": o Y , ' X+Y=' , ": o (X+Y) , ' X*Y=' , ": o (X*Y)

solve=. show :: (''"_) o filter3 o filter2 o filter1 o (] filter0 decompositions) f.
