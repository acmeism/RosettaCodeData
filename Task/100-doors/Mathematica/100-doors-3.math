Fold[
 ReplacePart[#1, (i_ /; Mod[i, #2] == 0) :> (-#1[[i]])] &,
 ConstantArray[-1, {100}],
 Range[100]
] /. {1 -> "Open", -1 -> "Closed"}
