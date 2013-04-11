program shortcircuit(output);

function a(value: boolean): boolean;
 begin
  writeln('a(', value, ')');
  a := value
 end;

function b(value:boolean): boolean;
 begin
  writeln('b(', value, ')');
  b := value
 end;

procedure scandor(value1, value2: boolean);
 var
  result: boolean;
 begin
  {and}
  if a(value1)
   then
    result := b(value2)
   else
    result := false;
  writeln(value1, ' and ', value2, ' = ', result);

  {or}
  if a(value1)
   then
    result := true
   else
    result := b(value2)
  writeln(value1, ' or ', value2, ' = ', result);
 end;

begin
 scandor(false, false);
 scandor(false, true);
 scandor(true, false);
 scandor(true, true);
end.
