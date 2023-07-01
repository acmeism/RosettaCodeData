Data =
(
>Rosetta_Example_1
THERECANBENOSPACE
>Rosetta_Example_2
THERECANBESEVERAL
LINESBUTTHEYALLMUST
BECONCATENATED
)

Data := RegExReplace(RegExReplace(Data, ">\V+\K\v+", ": "), "\v+(?!>)")
Gui, add, Edit, w700,  % Data
Gui, show
return
