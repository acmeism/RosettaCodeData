AddSumSquare[input_]:=Append[input,Total[IntegerDigits[Last[input]]^2]]
NestUntilRepeat[a_,f_]:=NestWhile[f,{a},!MemberQ[Most[Last[{##}]],Last[Last[{##}]]]&,All]
HappyQ[a_]:=Last[NestUntilRepeat[a,AddSumSquare]]==1
