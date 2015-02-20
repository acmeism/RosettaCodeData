program numlist(output);

const MAXNUM: integer = 10;
var
  i: integer;

begin
  { loop 1: w/ if branching }
  for i := 1 to MAXNUM do
    begin
      write(i);
      if i <> MAXNUM then
        write(', ')
    end;
  writeln;
  { loop 2: w/o if branching }
  for i := 1 to MAXNUM-1 do
    write(i, ', ');
  writeln(MAXNUM);
end.
