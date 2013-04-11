CombinWithRep[S_List, k_] := Module[{occupation, assignment},
  occupation =
   Flatten[Permutations /@
     IntegerPartitions[k, {Length[S]}, Range[0, k]], 1];
  assignment =
   Flatten[Table[ConstantArray[z, {#[[z]]}], {z, Length[#]}]] & /@
    occupation;
  Thread[S[[#]]] & /@ assignment
  ]

In[2]:= CombinWithRep[{"iced", "jam", "plain"}, 2]

Out[2]= {{"iced", "iced"}, {"jam", "jam"}, {"plain",
  "plain"}, {"iced", "jam"}, {"iced", "plain"}, {"jam", "plain"}}
