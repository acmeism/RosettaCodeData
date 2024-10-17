in=: {{n&{ i. m"_}}             NB. index of m in row n of matrix
F =: {{u"_1 # ]}}               NB. filter by function of items
'Col Nat Pet Drink Cig'=: i.5   NB. refer to rows by name
'col nat pet drink cig'=: (A.~i.@!@#)&>;:'BGRWY DEGNS BCDHZ BCMTW BbDpP'  NB. perm matrices
P=: ('W' in Col (= >:) 'G' in Col)F ,/col,:"1/nat  NB. join first two mats and add 1st constraint
P=: ,/pet,"2 1/~ (('E' in Nat = 'R' in Col)*.(0 = 'N' in Nat))F P  NB. and so on...
P=: ,/drink,"2 1/~ (('D' in Pet = 'S' in Nat)*.('N' in Nat (1=|@:-) 'B' in Col))F P
P=: (('C' in Drink = 'G' in Col)*.(2 = 'M' in Drink))F P
P=: (('T' in Drink = 'D' in Nat)*.('p' in Cig = 'B' in Pet))F ,/P,"2 1/cig
P=: (('D' in Cig = 'Y' in Col)*.('b' in Cig = 'B' in Drink))F P
P=: (('P' in Cig = 'G' in Nat)*.('B' in Cig (1=|@:-) 'C' in Pet))F P
P=: (('D' in Cig (1=|@:-) 'H' in Pet)*.('B' in Cig (1=|@:-) 'W' in Drink))F P
echo 'Solutions found: ',(":#P),LF,LF,~' owns the Z',~('Z' in Pet { Nat&{){.P
echo 'Col    Nat    Pet    Drink  Cig', ([,(6#' '),])/"1|:{.P
