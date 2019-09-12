program castout9;
{$ifdef fpc}{$mode delphi}{$endif}
uses generics.collections;
type
  TIntegerList = TSortedList<integer>;

procedure co9(const start,base,lim:integer;kaprekars:array of integer);
var
  C1:integer = 0;
  C2:integer = 0;
  S:TIntegerlist;
  k,i:integer;
begin
  S:=TIntegerlist.Create;
  for k := start to lim do
  begin
    inc(C1);
    if k mod (base-1) = (k*k) mod (base-1) then
    begin
      inc(C2);
      S.Add(k);
    end;
  end;
  writeln('Valid subset: ');
  for i in Kaprekars do
    if not s.contains(i) then
      writeln('invalid ',i);

  for i in s do write(i:4);
  writeln;
  write('The Kaprekars in this range [');
  for i in kaprekars do write(i:4);
  writeln('] are included');
  writeln('Trying ',C2, ' numbers instead of ', C1,' saves ',100-(C2 * 100 /C1):3:2,',%.');
  writeln;
  S.Free;
end;

begin
  co9(1, 10, 99, [1,9,45,55,99]);
  co9(1, 10, 1000, [1,9,45,55,99,297,703,999]);
end.
