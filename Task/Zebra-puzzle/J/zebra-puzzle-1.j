in=: {{n&{ i. m"_}}             NB. index of m in row n of matrix
F =: {{u"_1 # ]}}               NB. filter by function of items
'Col Nat Pet Drink Cig'=: i.5   NB. refer to rows by name
'col nat pet drink cig'=: (A.~i.@!@#)&>BGRWY`DEGNS`BCDHZ`BCMTW`BbDpP  NB. perm matrices
P=: ,/col,:"1/nat               NB. join color and nationality matrices
P=: ('W' in Col = 1+ 'G' in Col)F P               NB. white right of green
P=: (0 = 'N' in Nat)F P                           NB. Norwegian in first house
P=: ,/pet,"2 1/~ ('E' in Nat = 'R' in Col)F P     NB. red = English; add pets
P=: ('N' in Nat (1=|@-) 'B' in Col)F P            NB. blue next to Norwegian
P=: ,/drink,"2 1/~ ('D' in Pet = 'S' in Nat)F P   NB. Swede owns dog; add drinks
P=: (2 = 'M' in Drink)F P                         NB. middle house drinks milk
P=: ('T' in Drink = 'D' in Nat)F P                NB. Dane drinks tea
P=: ('C' in Drink = 'G' in Col)F P                NB. green = coffee
P=: ('p' in Cig = 'B' in Pet)F ,/P,"2 1/cig       NB. add cigs; PallMall = birds
P=: ('D' in Cig = 'Y' in Col)F P                  NB. Dunhill = yellow
P=: ('b' in Cig = 'B' in Drink)F P                NB. BlueM = beer
P=: ('P' in Cig = 'G' in Nat)F P                  NB. Prince = German
P=: ('B' in Cig (1=|@-) 'C' in Pet)F P            NB. cat next to Blend
P=: ('D' in Cig (1=|@-) 'H' in Pet)F P            NB. horse next to Dunhill
P=: ('B' in Cig (1=|@-) 'W' in Drink)F P          NB. water next to Blend
echo 'Solutions found: ',":#P
echo (('Z' in Pet { Nat&{){.P),' owns the Z'
echo 'Col    Nat    Pet    Drink  Cig'
echo ([,(6#' '),])/"1|:{.P
