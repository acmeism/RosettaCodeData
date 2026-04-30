program NumEqualRiseAndFalls;
{$MODE DELPHI}{$CODEALIGN proc=32}
const
  BASE = 10;

type
  tdigitsOfNum =  record
                   digit : array[0..23] of Uint8;
//                 risefall : array[0..23] of Uint8;
                   Num : Uint64;
                   risefall,
                   cntDigits:NativeInt;
                 end;
  tpdigitsOfNum = ^tdigitsOfNum;

function Numb2USA(n:Uint64):Ansistring;
var
  pI :pChar;
  i,j : NativeInt;
Begin
  str(n,result);
  i := length(result);
 //extend s by the count of comma to be inserted
  j := i+ (i-1) div 3;
  if i<> j then
  Begin
    setlength(result,j);
    pI := @result[1];
    dec(pI);
    while i > 3 do
    Begin
       //copy 3 digits
       pI[j] := pI[i];pI[j-1] := pI[i-1];pI[j-2] := pI[i-2];
       //insert comma
       pI[j-3] := ',';
       dec(i,3);
       dec(j,4);
    end;
  end;
end;
procedure IncDigits(res:tpdigitsOfNum;carry:NativeInt = 1);inline;
//carry must be in the range of 0..BASE-1
var
  dgt,idx,sgn: NativeInt;
Begin
  with res^ do
  begin
    num += carry;
    idx := 0;
    repeat
      dgt := digit[idx];
      dgt += carry;
      //IF dgt>= BASE then Begin carry:=1; dgt -= BASE;end;
      //version without IF
      carry := ORD(dgt>=Base);// [0,1]
      dgt -= BASE AND (-carry);// [0,BASE], BASE AND -1 = BASE

      digit[idx] := dgt;
      inc(idx);
    until (carry=0) OR (idx >= cntDigits);

    If carry <> 0 then
    begin
      digit[idx] := carry;
      inc(cntDigits);
    end;

    idx:= cntDigits-1;
    dgt :=0;
    while idx>0 do
    begin
      sgn := digit[idx];//digit[idx]-digit[idx-1];
      dec(idx);
      sgn -= digit[idx];
      sgn := Ord(sgn>0)-Ord(sgn<0);
      dgt += sgn;
//      risefall[idx]:= dgt;
    end;
    risefall := dgt;
  end;

end;

var
  cnt,lmt : Cardinal;
  myNum : tdigitsOfNum;
BEGIN
  writeln('Find numbers with rise and falls');

  lmt := 200;
  writeln('Limit ',Lmt);
  myNum.cntDigits := 1;
  cnt :=0;
  While cnt < lmt do
  begin
    IncDigits(@myNum);
    with mynum do
    begin
      if risefall = 0 then
      begin
        inc(cnt);
        write(num:4);
        if cnt Mod 20 = 0 then
          writeln;
      end;
    end;
  end;

  lmt := 1000*1000;
  while lmt <= 100*1000*1000 do
  begin
    While cnt < lmt do
    begin
      IncDigits(@myNum);
      with mynum do
        if risefall = 0 then
          inc(cnt);
    end;
    writeln('Limit ',Numb2USA(lmt):12,' -> ',Numb2USA(myNum.num):12);
    lmt *=10;
  end;
END.
