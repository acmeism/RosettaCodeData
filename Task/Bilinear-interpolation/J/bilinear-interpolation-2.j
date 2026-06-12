Note 'Some elemental information'

   Node order
   1D:

   0   2   1


   2D:

   2   7   3

   5   8   6   Node 8 at origin, Node 3 at (1,1)

   0   4   1

   Names for shape functions and constants:
   n249: n means shape function, 2 dimensions, 4 corners (quadrilateral), 9 nodes
   C244: C       constants for   2 dimensions, 4 corners (quadrilateral), 4 nodes


   3D
   At z = _1           z = 1            z = 0
   2   b   3           6   j   7        e   o   f

   9   k   a           h   p   i        m   q   n

   0   8   1           4   g   5        c   l   d
)
mp =: ($: |:) : (+/ .*)  NB. A Atranspose : matrix product A B
identity =: =@:i.        NB. generate identity matrix


NB. 1D
NB. master nodes
N1 =: ,._1 1 0x
NB. form of shape functions
n122 =: 1 , ]
n123 =: [: , ^/&(i.3)
NB. constants
C122 =: x:inv@:(x:@:identity@:# %. n122"1)2{.N1
C123 =: x:inv@:(x:@:identity@:# %. n123"1)3{.N1
NB. interpolants
i122 =: mp (C122 mp~ n122)
i123 =: mp (C123 mp~ n123)


NB. 2D
NB. nodes are arranged 4&{. are the corners, 8&{. the corners and edges, ] include the center.
N2 =: 336330 A.-.3x#.inv i.*:3   NB. 336330 (-: A.) 8 2 6 0 5 7 1 3 4

NB. terms of shape functions
n244 =: [: , [: *// ^/&(i.2)            NB. all linear combinations
n248 =: }:@:n249                        NB. exclude (xi eta)^2
n249 =: [: , [: *// ^/&(i.3)            NB. all quadratic combinations

NB. constants
C244 =: x:inv@:(x:@:identity@:# %. n244"1)4{.N2 NB. serendipity
C248 =: x:inv@:(x:@:identity@:# %. n248"1)8{.N2 NB. serendipity
C249 =: x:inv@:(x:@:identity@:# %. n249"1)9{.N2 NB. non-serendipity

NB. interpolants
i244 =: mp (C244 mp~ n244)
i248 =: mp (C248 mp~ n248)
i249 =: mp (C249 mp~ n249)

NB. 3D
N3 =: 267337661061030402017459663x A.<:3#.inv i.3^3  NB. 267337661061030402017459663x (-: A.) 0 18 6 24 2 20 8 26 9 3 21 15 1 19 7 25 11 5 23 17 12 10 4 22 16 14 13
NB. corners
n388 =: [: , [: *// 1 , ]               NB. all linear combinations

Note 'simplification not yet apparent to me'
   combinations =: 4 : 0
     if. x e. 0 1 do. z=.<((x!y),x)$ i.y
     else. t=. |.(<.@-:)^:(i.<. 2^.x)x
       z=.({.t) ([:(,.&.><@;\.)/ >:@-~[\i.@]) ({.t)+y-x
       for_j. 2[\t do.
         z=.([ ;@:(<"1@[ (,"1 ({.j)+])&.> ])&.> <@;\.({&.><)~ (1+({.j)-~{:"1)&.>) z
         if. 2|{:j do. z=.(i.1+y-x)(,.>:)&.> <@;\.z end.
       end.
     end.
     ;z
   NB.)
   n38k =: 1 , ] , */"1@:((2 combinations 3)&{) , *: , (1&, * */) , ,@:(*:@:|. (*"0 1) (2 combinations 3)&{) NB. include mid-edge nodes
)
n38q =: }:@:n38r             NB. include mid-face nodes, all quadratic combinations but (xyz)^2
n38r =: [: , [: *// ^/&(i.3) NB. now this is simple!  3*3*3 nodal grid.
C388 =: x:inv@:(x:@:identity@:# %. n388"1)8{.N3
NB.C38k =: x:inv@:(x:@:identity@:# %. n38k"1)36bk{.N3
C38q =: x:inv@:(x:@:identity@:# %. x:@:n38q"1)36bq{.N3
C38r =: x:inv@:(x:@:identity@:# %. x:@:n38r"1)36br{.N3
i388 =: mp (C388 mp~ n388)
NB.i38k =: mp (C38k mp~ n38k)
i38q =: mp (C38r mp~ n38r)
i38r =: mp (C38r mp~ n38r)
