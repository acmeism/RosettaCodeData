begin
  var s := '''
  ABCD
  CABD
  ACDB
  DACB
  BCDA
  ACBD
  ADCB
  CDAB
  DABC
  BCAD
  CADB
  CDBA
  CBAD
  ABDC
  ADBC
  BDCA
  DCBA
  BACD
  BADC
  BDAC
  CBDA
  DBCA
  DCAB
  ''';
  var perms := s.ToLines;
  Print(('ABCD'.Permutations.ToHashSet - perms.ToHashSet).First);
end.
