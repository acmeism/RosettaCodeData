Positive =: adverb define
 'non-positive' assert *./ , y > 0
 u y
)
Integral =: adverb define
 'non-integral' assert (-: <.) y
 u y
)
display =: smoutput :[:
display_positive_integers =: display Integral Positive

   display 1 3 8
1 3 8
   display_positive_integers 1 3 8
1 3 8
   display 1x1 _1p1
2.71828 _3.14159
   display_positive_integers 1x1 _1p1
|non-positive: assert
|   'non-positive'    assert*./,y>0
