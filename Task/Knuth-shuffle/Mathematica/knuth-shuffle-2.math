Shuffle[input_List /; Length[input] >= 1] :=
 Module[{indices = {}, allindices = Range[Length[input]]},
  Do[
   AppendTo[indices,
     Complement[allindices, indices][[RandomInteger[{1, i}]]]];
   ,
   {i, Length[input], 1, -1}
   ];
  input[[indices]]
  ]
