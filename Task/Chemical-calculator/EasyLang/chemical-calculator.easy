weight[] = [ 1.01 4.00 6.94 9.01 10.81 12.01 14.01 16.00 19.00 20.18 22.99 24.30 26.98 28.09 30.97 32.06 35.45 39.10 39.95 40.08 44.96 47.87 50.94 52.00 54.94 55.84 58.69 58.93 63.55 65.38 69.72 72.63 74.92 78.97 79.90 83.80 85.47 87.62 88.91 91.22 92.91 95.95 101.07 102.91 106.42 107.87 112.41 114.82 118.71 121.76 126.90 127.60 131.29 132.91 137.33 138.91 140.12 140.91 144.24 145 150.36 151.96 157.25 158.93 162.50 164.93 167.26 168.93 173.05 174.97 178.49 180.95 183.84 186.21 190.23 192.22 195.08 196.97 200.59 204.38 207.20 208.98 209 210 222 223 226 227 231.04 232.04 237 238.03 243 244 247 247 251 252 257 299 315 ]
name$[] = [ "H" "He" "Li" "Be" "B" "C" "N" "O" "F" "Ne" "Na" "Mg" "Al" "Si" "P" "S" "Cl" "K" "Ar" "Ca" "Sc" "Ti" "V" "Cr" "Mn" "Fe" "Ni" "Co" "Cu" "Zn" "Ga" "Ge" "As" "Se" "Br" "Kr" "Rb" "Sr" "Y" "Zr" "Nb" "Mo" "Ru" "Rh" "Pd" "Ag" "Cd" "In" "Sn" "Sb" "I" "Te" "Xe" "Cs" "Ba" "La" "Ce" "Pr" "Nd" "Pm" "Sm" "Eu" "Gd" "Tb" "Dy" "Ho" "Er" "Tm" "Yb" "Lu" "Hf" "Ta" "W" "Re" "Os" "Ir" "Pt" "Au" "Hg" "Tl" "Pb" "Bi" "Po" "At" "Rn" "Fr" "Ra" "Ac" "Pa" "Th" "Np" "U" "Am" "Pu" "Cm" "Bk" "Cf" "Es" "Fm" "Ubn" "Uue" ]
func getw n$ .
   for i to len name$[]
      if n$ = name$[i]
         return weight[i]
      .
   .
   print "Error: " & n$ & " no such element"
   return 0
.
subr nextch
   if inp_ind > len inp$[]
      ch$ = strchar 0
   else
      ch$ = inp$[inp_ind]
      inp_ind += 1
   .
   ch = strcode ch$
.
subr nexttok
   if ch = 0
      tok$ = "eof"
   elif ch >= 48 and ch <= 58
      tok$ = "numb"
      tokv$ = ""
      while ch >= 48 and ch <= 58 or ch$ = "."
         tokv$ &= ch$
         nextch
      .
   elif ch >= 65 and ch <= 90
      tok$ = "elem"
      tokv$ = ch$
      nextch
      while ch >= 97 and ch <= 122
         tokv$ &= ch$
         nextch
      .
   else
      tokv$ = ch$
      tok$ = ch$
      nextch
   .
.
func eval .
   while tok$ = "(" or tok$ = "elem"
      if tok$ = "("
         nexttok
         w = eval
         if tok$ <> ")"
            print "error: ) expected"
         .
         nexttok
         if tok$ = "numb"
            w *= number tokv$
            nexttok
         .
         sum += w
      elif tok$ = "elem"
         w = getw tokv$
         nexttok
         if tok$ = "numb"
            w *= number tokv$
            nexttok
         .
         sum += w
      .
   .
   return sum
.
func molw s$ .
   inp$[] = strchars s$
   inp_ind = 1
   nextch
   nexttok
   w = eval
   if tok$ <> "eof"
      print "error: " & tokv$
   .
   return w
.
molecules$[] = [ "H" "H2" "H2O" "H2O2" "(HO)2" "Na2SO4" "C6H12" "COOH(C(CH3)2)3CH3" "C6H4O2(OH)4" "C27H46O" "Uue" ]
for m$ in molecules$[]
   print m$ & " -> " & molw m$
.
