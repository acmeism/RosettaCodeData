ProvidedSet = {"ABCD" , "CABD" , "ACDB" , "DACB" , "BCDA" , "ACBD",
"ADCB" , "CDAB", "DABC", "BCAD" , "CADB", "CDBA" , "CBAD" , "ABDC",
"ADBC" , "BDCA",  "DCBA" , "BACD", "BADC", "BDAC" , "CBDA", "DBCA", "DCAB"}

Part[Complement[ Map[ StringJoin , Permutations[Characters[RandomChoice[ProvidedSet]]]], ProvidedSet], 1]

->"DBAC"
