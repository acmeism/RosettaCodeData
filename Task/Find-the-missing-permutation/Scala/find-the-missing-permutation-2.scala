println("missing perms: "+("ABCD".permutations.toSet
  --"ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB".stripMargin.split(" ").toSet))
