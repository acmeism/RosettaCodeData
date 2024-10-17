   o=. @: NB. Composition of verbs (functions)
   x=. o[ NB. Composing the left noun (argument)

   (rows2up=. ,&'&1'&'2x&*') o i. 4
2x&*
2x&*&1
2x&*&1&1
2x&*&1&1&1
   NB. 2's multiplication, exponentiation, tetration, pentation, etc.

   0 1 2 (BuckTruncated=. (rows2up  x apply ]) f.) 0 1 2 3 4 5
0 2 4  6     8                                                                                                                                                                                                                                                  ...
1 2 4  8    16                                                                                                                                                                                                                                                  ...
1 2 4 16 65536 2003529930406846464979072351560255750447825475569751419265016973710894059556311453089506130880933348101038234342907263181822949382118812668869506364761547029165041871916351587966347219442930927982084309104855990570159318959639524863372367203...
   NB. Buck truncated function (missing the first two rows)

   BuckTruncated NB. Buck truncated function-level code
,&'&1'&'2x&*'@:[ 128!:2 ]

   (rows01=. {&('>:',:'2x&+')) 0 1 NB. The missing first two rows
>:
2x&+

   Buck=. (rows01 :: (rows2up o (-&2)))"0 x apply ]

   (Ack=. (3 -~ [ Buck 3 + ])f.)  NB. Ackermann function-level code
3 -~ [ ({&(2 4$'>:  2x&+') ::(,&'&1'&'2x&*'@:(-&2))"0@:[ 128!:2 ]) 3 + ]
