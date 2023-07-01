- Int.fromString "0123459";
val it = SOME 123459 : int option
- StringCvt.scanString (Int.scan StringCvt.HEX) "0xabcf123";
val it = SOME 180154659 : int option
- StringCvt.scanString (Int.scan StringCvt.HEX) "abcf123";
val it = SOME 180154659 : int option
- StringCvt.scanString (Int.scan StringCvt.OCT) "7651";
val it = SOME 4009 : int option
- StringCvt.scanString (Int.scan StringCvt.BIN) "101011001";
val it = SOME 345 : int option
