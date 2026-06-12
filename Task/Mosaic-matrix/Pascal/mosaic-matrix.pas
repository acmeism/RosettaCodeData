program mosaicMatrix(output);

const
  filledCell = '1';
  emptyCell = '⋅';

procedure printMosaicMatrix(dimension: integer);
var
  line: integer;
begin
  { NB: In Pascal, `for`-loop-limits are evaluated exactly once. }
  for line := 1 to dimension do
  begin
    for dimension := 1 to dimension do
    begin
      { `ord(odd(line))` is either zero or one. }
      if odd(dimension + ord(odd(line))) then
      begin
        { `write(emptyCell)` is shorthand for `write(output, emptyCell)`. }
        write(emptyCell)
      end
      else
      begin
        write(filledCell)
      end
    end;
    writeLn
  end
end;

begin
  printMosaicMatrix(9)
end.
