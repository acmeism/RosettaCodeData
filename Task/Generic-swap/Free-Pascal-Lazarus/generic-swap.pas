{$ifdef fpc}{$mode delphi}{$H+}{$endif}
{ note this is compiled with delphi mode but will only compile in Free Pascal }
{ Delphi doesn't support this syntax                                          }
procedure swap<T>(var left,right:T);
var
  temp:T;
begin
  temp:=left;
  left:=right;
  right:=temp;
end;
var
  a:string = 'Test';
  b:string = 'me';
begin
  writeln(a:6,b:6);
  swap<string>(a,b);
  writeln(a:6,b:6);
end.
