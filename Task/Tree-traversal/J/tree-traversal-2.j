N2=: conjunction def '(<m),(<n),<y'
N1=: adverb def '(<m),<y'
L=: adverb def '<m'

tree=: 1 N2 (2 N2 (4 N1 (7 L)) 5 L) 3 N1 6 N2 (8 L) 9 L
