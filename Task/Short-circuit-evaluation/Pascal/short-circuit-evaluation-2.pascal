program shortcircuit;

function a(value: boolean): boolean;
 begin
  writeln('a(', value, ')');
  a := value;
 end;

function b(value:boolean): boolean;
 begin
  writeln('b(', value, ')');
  b := value;
 end;

{$B-} {enable short circuit evaluation}
procedure scandor(value1, value2: boolean);
 var
  result: boolean;
 begin
  result :=  a(value1) and b(value);
  writeln(value1, ' and ', value2, ' = ', result);

  result := a(value1) or b(value2);
  writeln(value1, ' or ', value2, ' = ', result);
 end;

begin
 scandor(false, false);
 scandor(false, true);
 scandor(true, false);
 scandor(true, true);
end.
