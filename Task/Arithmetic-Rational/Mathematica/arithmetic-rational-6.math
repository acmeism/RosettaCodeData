found={};
CheckPerfect[num_Integer]:=If[Total[1/Divisors[num]]==2,AppendTo[found,num]];
Do[CheckPerfect[i],{i,1,2^25}];
found
