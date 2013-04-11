maxWords[language_String] :=  Module[{max,data = Select[DictionaryLookup[{language, "*"}],OrderedQ[Characters[#]] &]},
  max = Max[StringLength /@ data];
  Select[data, StringLength[#] == max &]]
