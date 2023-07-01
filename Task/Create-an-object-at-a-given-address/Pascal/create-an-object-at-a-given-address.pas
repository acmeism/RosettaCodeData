program test;
type
  t8Byte =  array[0..7] of byte;
var
  I : integer;
  A : integer absolute I;
  K : t8Byte;
  L : Int64 absolute K;
begin
  I := 0;
  A := 255; writeln(I);
  I := 4711;writeln(A);

  For i in t8Byte do
  Begin
    K[i]:=i;
    write(i:3,' ');
  end;
  writeln(#8#32);
  writeln(L);
end.
