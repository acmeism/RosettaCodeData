splits = Gather[list, Sort[Characters[#]] == Sort[Characters[#2]] &];
maxlen = Max[Length /@ splits];
Select[splits, Length[#] == maxlen &]
