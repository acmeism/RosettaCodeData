uses sysutils;
var
  { declaration is creation }
  a,b:string;
  { creation with default value }
  c:string = 'this is a string';
begin
  { assignment }
  a := 'test';
  b := 'test';
  writeln(a:6, b:6);
  { comparison }
  writeln('equal? ', a = b );
  { empty string }
  writeln('empty? ', a = '');
  { cloning, copying }
  a := c;
  writeln('copy c to a, a is now: ', a);
  { append }
  b := b +'W';
  writeln('append W to b: ',b);
  { extract substring }
  b := copy(a,6,2);
  writeln('this should be is": ',b);
  { replace }
  a := stringreplace(a,'i','I',[rfReplaceAll]);
  writeln('replace i with I: ',a);
  { join }
  a:= concat(b,c);
  writeln('join b and c; ',a);
end.
