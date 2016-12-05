IMPORT STD;
RomanDecode(STRING s) := FUNCTION
  SetWeights := [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
  SetSymbols := ['M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I'];
  ProcessRec := RECORD
    UNSIGNED val;
    STRING Roman;
  END;
  dsSymbols := DATASET(13,TRANSFORM(ProcessRec,SELF.Roman := s, SELF := []));
	
  RECORDOF(dsSymbols) XF(dsSymbols L, dsSymbols R, INTEGER C) := TRANSFORM
    ThisRoman := IF(C=1,R.Roman,L.Roman);
    IsDone := ThisRoman = '';
    Repeatable := C IN [1,5,9,13];
    SymSize := IF(C % 2 = 0, 2, 1);
    IsNext := STD.Str.StartsWith(ThisRoman,SetSymbols[C]);
    SymLen := IF(IsNext,
                 IF(NOT Repeatable,
                    SymSize,
                    MAP(NOT IsDone AND ThisRoman[1] = ThisRoman[2] AND ThisRoman[1] = ThisRoman[3] => 3,
                        NOT IsDone AND ThisRoman[1] = ThisRoman[2] => 2,
                        NOT IsDone  => 1,
                        0)),
                 0);

    SymbolWeight(STRING s) := IF(NOT Repeatable,
                                 SetWeights[C],
                                 CHOOSE(LENGTH(s),SetWeights[C],SetWeights[C]*2,SetWeights[C]*3,0));

    SELF.Roman := IF(IsDone,ThisRoman,ThisRoman[SymLen+1..]);
    SELF.val   := IF(IsDone,L.val,L.Val + IF(IsNext,SymbolWeight(ThisRoman[1..SymLen]),0));
  END;
  i := ITERATE(dsSymbols,XF(LEFT,RIGHT,COUNTER));
  RETURN i[13].val;
END;

RomanDecode('MCMLIV');   //1954
RomanDecode('MCMXC');    //1990
RomanDecode('MMVIII');   //2008
RomanDecode('MDCLXVI');  //1666
RomanDecode('MDLXVI');   //1566
