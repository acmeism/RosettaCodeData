   # ludic 110  NB. 110 is sufficient to generate 25 Ludic numbers
25
   ludic 110    NB. First 25 Ludic numbers
1 2 3 5 7 11 13 17 23 25 29 37 41 43 47 53 61 67 71 77 83 89 91 97 107

   #ludic 1000  NB. 142 Ludic numbers <= 1000
142

   # ludic 22000   NB. 22000 is sufficient to generate > 2005 Ludic numbers
2042
   (2000+i.6) { ludic 22000  NB. Ludic numbers 2000-2005
21481 21487 21493 21503 21511 21523

   0 2 6 (] (*./ .e.~ # |:@]) +/) ludic 250  NB. Ludic triplets <= 250
  1   3   7
  5   7  11
 11  13  17
 23  25  29
 41  43  47
173 175 179
221 223 227
233 235 239
