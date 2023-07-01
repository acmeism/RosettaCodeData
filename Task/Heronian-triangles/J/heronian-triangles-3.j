   Tri=:(1-i.3)+"1]3 comb 202                     NB. distinct triangles with sides <= 200
   HeroTri=: (#~ isPrimHero) Tri                  NB. all primitive Heronian triangles with sides <= 200

   # HeroTri                                      NB. count triangles found
517

   HeroTri=: (/: area ,. perim ,. ]) HeroTri      NB. sort by area, perimeter & sides

   (,. _ ,. perim ,. area) 10 {. HeroTri          NB. tabulate sides, perimeter & area for top 10 triangles
 3  4  5 _ 12  6
 5  5  6 _ 16 12
 5  5  8 _ 18 12
 4 13 15 _ 32 24
 5 12 13 _ 30 30
 9 10 17 _ 36 36
 3 25 26 _ 54 36
 7 15 20 _ 42 42
10 13 13 _ 36 60
 8 15 17 _ 40 60

   (,. _ ,. perim ,. area) (#~ 210 = area) HeroTri NB. tablulate sides, perimeter & area for triangles with area = 210
17  25  28 _  70 210
20  21  29 _  70 210
12  35  37 _  84 210
17  28  39 _  84 210
 7  65  68 _ 140 210
 3 148 149 _ 300 210
