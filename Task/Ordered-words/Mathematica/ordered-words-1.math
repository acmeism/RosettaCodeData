Module[{max,
   data = Select[Import["http://www.puzzlers.org/pub/wordlists/unixdict.txt", "List"],
     OrderedQ[Characters[#]] &]},
  max = Max[StringLength /@ data];
  Select[data, StringLength[#] == max &]]
