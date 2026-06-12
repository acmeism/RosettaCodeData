program strangenumbers;

const
  dgtMaxCnt = 10;
  deltaDgtCnt: array[0..9] of Int32 =(4,4,5,5,5,5,5,5,4,4); // (4*4+6*5)/10 =>  4.6
  // digits that can follow
  DPrmNxtDgt : array[0..9,0..4] of Int32 =((2,3,5,7,0),  //0 +2,+3,+5,+7
                                           (3,4,6,8,0),  //1 +2,+3,+5,+7
                                           (0,4,5,7,9),  //2 -2,+2,+3,+5,+7
                                           (0,1,5,6,8),  //3 -3,-2,+2,+3,+5
                                           (1,2,6,7,9),  //4 -3,-2,+2,+3,+5
                                           (0,2,3,7,8),  //5 -5,-3,-2,+2,+3
                                           (1,3,4,8,9),  //6 -5,-3,-2,+2,+3
                                           (0,2,4,5,9),  //7 -7,-5,-3,-2,+2
                                           (1,3,5,6,0),  //8 -7,-5,-3,-2
                                           (2,4,6,7,0)); //9 -7,-5,-3,-2
type
  tDigits = array[0..dgtMaxCnt-1] of Int32;

//globals are set to 0
var
  Digits : tDigits;
  i,Cnt,dgtCnt : Int32;

procedure OutPut(const Digits:tDigits);
var
  i : Int32;
Begin
  For i := 0 to dgtcnt-1 do
    write(Digits[i]);
  write(' ');
end;

procedure NextDigit(var Digits:TDigits;DgtIdx:Int32);
var
  idx,dgt :Int32;
Begin
  dgt := Digits[DgtIdx];
  inc(DgtIdx);
  IF DgtIdx < dgtCnt-1 then
  Begin
    For idx := 0 to deltaDgtCnt[dgt]-1 do
    Begin
      Digits[DgtIdx]:= DPrmNxtDgt[dgt,idx];
      NextDigit(Digits,DgtIdx);
    end;
  end
  else
  Begin
    For idx := 0 to deltaDgtCnt[dgt]-1 do
    Begin
      Digits[DgtIdx]:= DPrmNxtDgt[dgt,idx];
      inc(cnt);
      IF dgtCnt<5 then
      Begin
        OutPut(Digits);
        If cnt mod 16 = 0 then
          Writeln;
      end;
    end;
  end;
end;

Begin
  cnt := 0;
  dgtCnt := 3;
  Writeln('Count of digits : ', dgtCnt,' in 100..499');
  For i := 1 to 4 do
  Begin
    Digits[0] := i;
    NextDigit(Digits,0);
  end;
  Writeln;
  Writeln('Count : ',cnt);
  Writeln;

  cnt := 0;
  dgtCnt := 10;
  Writeln('Count of digits : ', dgtCnt);
  For i := 1 to 1 do
  Begin
    Digits[0] := i;
    NextDigit(Digits,0);
  end;
  Writeln;
  Writeln('Count : ',cnt);
end.
