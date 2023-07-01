PT=: (' ',.~[;._2) {{)n
   1   2   3   4  5  6  7  8  9  10 11 12 13 14 15 16 17 18
 1 H                                                     He
 2 Li  Be                                 B  C  N  O  F  Ne
 3 Na  Mg                                 Al Si P  S  Cl Ar
 4 K   Ca  Sc  Ti V  Cr Mn Fe Co Ni Cu Zn Ga Ge As Se Br Kr
 5 Rb  Sr  Y   Zr Nb Mo Tc Ru Rh Pd Ag Cd In Sn Sb Te I  Xe
 6 Cs  Ba  *   Hf Ta W  Re Os Ir Pt Au Hg Tl Pb Bi Po At Rn
 7 Fr  Ra  -   Rf Db Sg Bh Hs Mt Ds Rg Cn Nh Fl Mc Lv Ts Og
 8 Lantanoidi* La Ce Pr Nd Pm Sm Eu Gd Tb Dy Ho Er Tm Yb Lu
 9  Aktinoidi- Ak Th Pa U  Np Pu Am Cm Bk Cf Es Fm Md No Lr
}}

ptrc=: {{
  tokens=. (#~ (3>#)@> * */@(tolower~:toupper)@>) ~.,;:,PT
  ndx=. (>' ',L:0' ',L:0~tokens) {.@I.@E."1 ,PT
  Lantanoidi=. ndx{+/\'*'=,PT
  Aktinoidi=. ndx{+/\'-'=,PT
  j=. 13|3*Lantanoidi+3*Aktinoidi
  k=. {:$PT
  0,}."1/:~j,.(<.ndx%k),.1+(/:~@~. i. ])k|ndx
}}

rowcol=: ptrc''
