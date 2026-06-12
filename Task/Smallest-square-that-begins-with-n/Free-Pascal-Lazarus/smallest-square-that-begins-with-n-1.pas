program LowSquareStartN;
uses
  sysutils;

function LowSquareStartN(N: Uint32):Uint32;
{Find lowest square that matches N}
var
  sqrtN,sqrtN_10,dez : double;
  mySqr : Uint64;
  Pow10 : int64;
begin
  dez := 10;
  Pow10:= 1;
  sqrtN  := sqrt(n);
  //to stay more accurate, instead *sqrt(10);
  sqrtN_10 := sqrt(n*dez);// one more decimal digit
  mySqr := n;
  repeat
    result := Trunc(sqrtN);
    mySqr := result*result;
    mySqr := mySqr DIV Pow10;
    if mySqr = n then EXIT;
    //test only next number
    inc(result);
    mySqr := (result*result);
    mySqr := mySqr DIV pow10;
    if mySqr = n then EXIT;

    pow10 *= 10;
    result := Trunc(sqrtN_10);
    mySqr := result*result;
    mySqr := mySqr DIV pow10;
    if mySqr = n then EXIT;
    inc(result);
    mySqr := result*result;
    mySqr := mySqr DIV pow10;
    if mySqr = n then EXIT;

    pow10 *= 10;
    sqrtN *= dez;
    sqrtN_10 *=dez;
  until sqrtN > Uint32(-1);
  exit(0);readln;
end;

procedure SquareStartsN();
{Find smallest square that begins with N}
var
  T : Uint64;
  i : Uint32;
begin
  writeln('Test 1 .. 49');
  for I:=1 to 49 do
  begin
    T:=LowSquareStartN(I);
    write(T*T:7); if i mod 10 = 0 then  writeln;
  end;
  writeln;
  writeln;
  writeln('Test 999,991 .. 1,000,000');
  for I:= 1000*1000-9 to 1000*1000 do
  begin
    T:= LowSquareStartN(I);
    writeln(i:10,':',T:11,'->',t*t:20);
  end;
  writeln;
  T := GetTickCount64;
  for I:= 1 to 10*1000*1000-10 do
    LowSquareStartN(I);
  T := GetTickCount64-T;
  writeln('check 1..1E7 in ', T,' ms');
end;

BEGIN
  SquareStartsN();
END.
