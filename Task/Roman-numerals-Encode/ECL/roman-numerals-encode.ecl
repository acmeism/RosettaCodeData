RomanEncode(UNSIGNED Int) := FUNCTION
  SetWeights := [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
  SetSymbols := ['M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I'];
  ProcessRec := RECORD
    UNSIGNED val;
    STRING Roman;
  END;
  dsWeights  := DATASET(13,TRANSFORM(ProcessRec,SELF.val := Int, SELF := []));

  SymbolStr(i,n,STRING s) := CHOOSE(n+1,'',SetSymbols[i],SetSymbols[i]+SetSymbols[i],SetSymbols[i]+SetSymbols[i]+SetSymbols[i],s);
	
  RECORDOF(dsWeights) XF(dsWeights L, dsWeights R, INTEGER C) := TRANSFORM
    ThisVal := IF(C=1,R.Val,L.Val);
    IsDone := ThisVal = 0;
    SELF.Roman := IF(IsDone,L.Roman,L.Roman + SymbolStr(C,ThisVal DIV SetWeights[C],L.Roman));
    SELF.val := IF(IsDone,0,ThisVal - ((ThisVal DIV SetWeights[C])*SetWeights[C]));
  END;
  i := ITERATE(dsWeights,XF(LEFT,RIGHT,COUNTER));
  RETURN i[13].Roman;
END;

RomanEncode(1954);  //MCMLIV
RomanEncode(1990 ); //MCMXC
RomanEncode(2008 ); //MMVIII
RomanEncode(1666);  //MDCLXVI
