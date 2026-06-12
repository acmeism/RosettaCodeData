program PandigitalPrime;
uses
  SysUtils;
type
  tDigits = set of 0..7;
const
  cPanDigits : array['0'..'1'] of string=('76543210','7654321');
  cDigits : array['0'..'1'] of tDigits  =([0..7],[1..7]);
var
  s : String;
  x,i,l : NativeInt;
  check,myCheck : tDigits;
  sp : char;
begin
  for sp := '0' to '1' do
  Begin
    myCheck := cDigits[sp];
    val(cPanDigits[sp],x,i);
    l := length(cPanDigits[sp]);
    //only odd numbers
    IF Not(Odd(x)) then
      dec(x);
    inc(x,2);

    repeat
      dec(x,2);
      //early checking
      if x mod 3 = 0 then
        continue;

      str(x,s);
      if length(s)<l then
        BREAK;

      //check pandigital
      check := myCheck;
      For i := 1 to l do
        Exclude(check,Ord(s[i])-Ord('0'));
      if check <> [] then
        continue;

      //rest of prime check
      i := 5;
      repeat
        if x mod i = 0 then BREAK;
        Inc(i, 2);
        if x mod i = 0 then BREAK;
        Inc(i, 4);
      until i * i >= x;

      if i*i> x then
      Begin
        Writeln(Format('%s..7: %d', [sp, x]));
        Break;
      end;
    until x <= 2;

  end;
end.
