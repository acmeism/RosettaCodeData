program LynchBell;
uses
  sysutils;

function CheckisLynch16(n: UInt64):Boolean;
const
  Base = 16;
  used16 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
var
  q : Uint64;
  m,i : Uint32;
  usedDIgits16: set of 0..BASE-1;
begin
  usedDigits16 := [];
  i := 0;
  repeat
    q := n DIV BASE;
    m := n -BASE * q;
    If (m in usedDIgits16) then
      BREAK
    else
      include(usedDIgits16,m);
    n := q;
    inc(i);
  until q = 0;
  EXIT(used16=usedDIgits16);
end;

procedure isLynchBell16;
//only digit 0 is not permitted
const
  magic= 15*14*13*12*11;//=2^3*3^2*5*7*11*13 = //divisible by 1..15
var
  n,cnt : Uint64;
begin
  n := $FEDCBA987654321 DIV magic *magic;
  cnt := 0;
  repeat
    inc(cnt);
    IF CheckisLynch16(n) then
    Begin
      Write('Largest hexadecimal number is:', FORMAT('%16X', [n]));
      writeln(' found in ',cnt,' steps');
      break;
    end;
    dec(n,magic);
  until n <magic;
end;

function CheckisLynch10(n: int64):boolean;
// can only be number of 7 digits with no 0,4,5 in it
const
  Base = 10;
  used10 = [1,2,3,6,7,8,9];
var
  usedDIgits : set of 0..BASE-1;
  q,m : integer;
begin
  usedDIgits := [];
  repeat
    q := n DIV BASE;
    m := n -BASE * q;
    If  m in usedDIgits then
      BREAK
    else
      include(usedDIgits,m);
    n := q;
  until q = 0;
  EXIT(used10=usedDIgits);
end;

procedure isLynchBell10;
const
  magic= 3*3*2*2*2* 7;//4,5 excluded  so divisible by 1,2,3,6,7,8,9
var
  n,cnt : Uint32;
begin
  n := 9876321 DIV magic *magic;
  cnt := 0;
  repeat
    inc(cnt);
    if CheckisLynch10(n) then
    Begin
      Writeln('Largest decimal number is:', n,' found in ',cnt,' steps');
      break;
    end;
    dec(n,magic);
  until n <magic;
end;

BEGIN
  isLynchBell10;
  isLynchBell16;
end.
