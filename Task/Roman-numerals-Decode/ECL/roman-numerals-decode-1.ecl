MapChar(STRING1 c) := CASE(c,'M'=>1000,'D'=>500,'C'=>100,'L'=>50,'X'=>10,'V'=>5,'I'=>1,0);

RomanDecode(STRING s) := FUNCTION
  dsS := DATASET([{s}],{STRING Inp});
  R := { INTEGER2 i; };

  R Trans1(dsS le,INTEGER pos) := TRANSFORM
    SELF.i := MapChar(le.Inp[pos]) * IF ( MapChar(le.Inp[pos]) < MapChar(le.Inp[pos+1]), -1, 1 );
  END;

  RETURN SUM(NORMALIZE(dsS,LENGTH(TRIM(s)),Trans1(LEFT,COUNTER)),i);
END;

RomanDecode('MCMLIV');   //1954
RomanDecode('MCMXC');    //1990
RomanDecode('MMVIII');   //2008
RomanDecode('MDCLXVI');  //1666
RomanDecode('MDLXVI');   //1566
