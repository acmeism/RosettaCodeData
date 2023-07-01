program primCons;
{$IFNDEF FPC}
  {$APPTYPE CONSOLE}
{$ENDIF}
const
  PrimeLimit =  2038074748 DIV 2;
type
  tLimit = 0..PrimeLimit;
  tCntTransition = array[0..9,0..9] of NativeInt;
  tCntTransRec = record
                   CTR_CntTrans:tCntTransition;
                   CTR_primCnt,
                   CTR_Limit : NativeInt;
                 end;
  tCntTransRecField = array[0..19] of tCntTransRec;
var
  primes: array [tLimit] of boolean;
  CntTransitions : tCntTransRecField;

procedure SieveSmall;
//sieve of eratosthenes with only odd numbers
var
  i,j,p: NativeInt;
Begin
  FillChar(primes[1],SizeOF(primes),chr(ord(true)));
  i := 1;
  p := 3;
  j := i*(i+1)*2;
  repeat
    IF (primes[i]) then
    begin
      p := i+i+1;
      repeat
        primes[j] := false;
        inc(j,p);
      until j > PrimeLimit;
    end;
    inc(i);
    j := i*(i+1)*2;//position of i*i
    IF PrimeLimit < j then
      BREAK;
  until false;
end;

procedure OutputTransitions(const Trs:tCntTransRecField);
var
  i,j,k,res,cnt: NativeInt;
  ThereWasOutput: boolean;
Begin
  cnt := 0;
  while Trs[cnt].CTR_primCnt > 0 do
    inc(cnt);
  dec(cnt);
  IF cnt < 0 then
    EXIT;

  write('PrimCnt ');
  For i := 0 to cnt do
    write(Trs[i].CTR_primCnt:i+7);
  writeln;
  For i := 0 to 9 do
  Begin
    ThereWasOutput := false;
    For j := 0 to 9 do
    Begin
      res := Trs[0].CTR_CntTrans[i,j];
      IF res > 0 then
      Begin
        ThereWasOutput := true;
        write('''',i,'''->''',j,'''');
        For k := 0 to cnt do
        Begin
          res := Trs[k].CTR_CntTrans[i,j];
          write(res/Trs[k].CTR_primCnt*100:k+6:k+2,'%');
        end;
        writeln;
      end;
    end;
    IF ThereWasOutput then
      writeln;
  end;
end;

var
  pCntTransOld,
  pCntTransNew  : ^tCntTransRec;
  i,primCnt,lmt : NativeInt;
  prvChr,
  nxtChr : NativeInt;
Begin
  SieveSmall;
  pCntTransOld := @CntTransitions[0].CTR_CntTrans;


  pCntTransOld^.CTR_CntTrans[2,3]:= 1;
  lmt := 10*1000;

  //starting at 2 *2+1 => 5
  primCnt := 2; // the prime 2,3
  prvChr := 3;
  nxtChr  := prvChr;
  for i:= 2 to PrimeLimit do
  Begin
    inc(nxtChr,2);
    if nxtChr >= 10 then nxtChr := 1;
    IF primes[i] then
    Begin
      inc(pCntTransOld^.CTR_CntTrans[prvChr][nxtChr]);
      inc(primCnt);
      prvchr := nxtChr;
      IF primCnt >= lmt then
      Begin
        with pCntTransOld^ do Begin
          CTR_Limit := i;
          CTR_primCnt := primCnt;
        end;
        pCntTransNew := pCntTransOld;
        inc(pCntTransNew);
        pCntTransNew^:= pCntTransOld^;
        pCntTransOld := pCntTransNew;
        lmt := lmt*10;
      end;
    end;
  end;
  pCntTransOld^.CTR_primCnt := 0;
  OutputTransitions(CntTransitions);
end.
