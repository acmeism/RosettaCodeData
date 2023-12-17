program LarPropDiv;

function LargestProperDivisor(n:NativeInt):NativeInt;
//searching upwards to save time for example 100
//2..sqrt(n) aka 1..10 instead downwards n..sqrt(n) 100..10
var
  i,j: NativeInt;
Begin
  i := 2;
  repeat
    If n Mod i = 0 then
    Begin
      LargestProperDivisor := n DIV i;
      EXIT;
    end;
    inc(i);
  until i*i > n;
  LargestProperDivisor := 1;
end;
var
  n : Uint32;
begin
  for n := 1 to 100 do
  Begin
    write(LargestProperDivisor(n):4);
    if n mod 10 = 0 then
      Writeln;
  end;
end.
