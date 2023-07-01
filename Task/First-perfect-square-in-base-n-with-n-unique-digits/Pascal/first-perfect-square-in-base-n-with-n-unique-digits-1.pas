program project1;
//Find the smallest number n to base b, so that n*n includes all
//digits of base b
{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}
uses
  sysutils;
const
 charSet : array[0..36] of char ='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
type
  tNumtoBase = record
                 ntb_dgt : array[0..31-4] of byte;
                 ntb_cnt,
                 ntb_bas  : Word;
               end;
var
  Num,
  sqr2B,
  deltaNum  : tNumtoBase;

function Minimal_n(base:NativeUint):Uint64;
//' 1023456789ABCDEFGHIJ...'
var
  i : NativeUint;
Begin
  result := base;  // aka '10'
  IF base > 2 then
    For i := 2 to base-1 do
      result := result*base+i;
  result := trunc(sqrt(result)+0.99999);
end;

procedure Conv2num(var num:tNumtoBase;n:Uint64;base:NativeUint);
var
  quot :UInt64;
  i :NativeUint;
Begin
  i := 0;
  repeat
    quot := n div base;
    Num.ntb_dgt[i] := n-quot*base;
    n := quot;
    inc(i);
  until n = 0;
  Num.ntb_cnt := i;
  Num.ntb_bas := base;
  //clear upper digits
  For i := i to high(tNumtoBase.ntb_dgt) do
     Num.ntb_dgt[i] := 0;
end;

procedure OutNum(const num:tNumtoBase);
var
  i : NativeInt;
Begin
  with num do
  Begin
    For i := 17-ntb_cnt-1 downto 0 do
      write(' ');
    For i := ntb_cnt-1 downto 0 do
      write(charSet[ntb_dgt[i]]);
  end;
end;

procedure IncNumBig(var add1:tNumtoBase;n:NativeUInt);
//prerequisites
//bases are the same,delta : NativeUint
var
  i,s,b,carry : NativeInt;
Begin
  b := add1.ntb_bas;
  i := 0;
  carry := 0;
  while n > 0 do
  Begin
    s := add1.ntb_dgt[i]+carry+ n MOD b;
    carry := Ord(s>=b);
    s := s- (-carry AND b);
    add1.ntb_dgt[i] := s;
    n := n div b;
    inc(i);
  end;

  while carry <> 0 do
  Begin
    s := add1.ntb_dgt[i]+carry;
    carry := Ord(s>=b);
    s := s- (-carry AND b);
    add1.ntb_dgt[i] := s;
    inc(i);
  end;

  IF add1.ntb_cnt < i then
    add1.ntb_cnt := i;
end;

procedure IncNum(var add1:tNumtoBase;carry:NativeInt);
//prerequisites: bases are the same, carry==delta < base
var
  i,s,b : NativeInt;
Begin
  b := add1.ntb_bas;
  i := 0;
  while carry <> 0 do
  Begin
    s := add1.ntb_dgt[i]+carry;
    carry := Ord(s>=b);
    s := s- (-carry AND b);
    add1.ntb_dgt[i] := s;
    inc(i);
  end;
  IF add1.ntb_cnt < i then
    add1.ntb_cnt := i;
end;

procedure AddNum(var add1,add2:tNumtoBase);
//prerequisites
//bases are the same,add1>add2, add1 <= add1+add2;
var
  i,carry,s,b : NativeInt;
Begin
  b := add1.ntb_bas;
  carry := 0;
  For i := 0 to add2.ntb_cnt-1 do
  begin
    s := add1.ntb_dgt[i]+add2.ntb_dgt[i]+carry;
    carry := Ord(s>=b);
    s := s- (-carry AND b);
    add1.ntb_dgt[i] := s;
  end;

  i := add2.ntb_cnt;
  while carry = 1 do
  Begin
    s := add1.ntb_dgt[i]+carry;
    carry := Ord(s>=b);
    // remove of if s>b then by bit-twiddling
    s := s- (-carry AND b);
    add1.ntb_dgt[i] := s;
    inc(i);
  end;

  IF add1.ntb_cnt < i then
    add1.ntb_cnt := i;
end;

procedure Test(base:NativeInt);
var
  n : Uint64;
  i,j,TestSet : NativeInt;
Begin
  write(base:5);
  n := Minimal_n(base);
  Conv2num(sqr2B,n*n,base);
  Conv2num(Num,n,base);
  deltaNum := num;
  AddNum(deltaNum,deltaNum);
  IncNum(deltaNum,1);

  i := 0;
  repeat
    //count used digits
    TestSet := 0;
    For j := sqr2B.ntb_cnt-1 downto 0 do
      TestSet := TestSet OR (1 shl sqr2B.ntb_dgt[j]);
    inc(TestSet);
    IF (1 shl base)=TestSet  then
       BREAK;
    //next square number
    AddNum(sqr2B,deltaNum);
    IncNum(deltaNum,2);
    inc(i);
  until false;
  IncNumBig(num,i);
  OutNum(Num);
  OutNum(sqr2B);
  Writeln(i:14);
end;

var
  T0: TDateTime;
  base :nativeInt;
begin
  T0 := now;
  writeln('base                 n        square(n)       Testcnt');
  For base := 2 to 16 do
    Test(base);
  writeln((now-T0)*86400:10:3);
  {$IFDEF WINDOWS}readln;{$ENDIF}
end.
