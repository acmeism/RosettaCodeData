program Project1;

{$APPTYPE CONSOLE}

uses
  SysUtils;
var
  matrix:array of array of Byte;
  i,j:Integer;
begin
  Randomize;
  //Finalization is not required in this case, but you have to do
  //so when reusing the variable in scope
  Finalize(matrix);
  //Init first dimension with random size from 1..10
  //Remember dynamic arrays are indexed from 0
  SetLength(matrix,Random(10) + 1);
  //Init 2nd dimension with random sizes too
  for i := Low(matrix) to High(matrix) do
    SetLength(matrix[i],Random(10) + 1);

  //End of code, the following part is just output
  Writeln(Format('Total amount of columns = %.2d',[Length(matrix)]));
  for i := Low(matrix) to High(matrix) do
    Writeln(Format('Column %.2d = %.2d rows',[i,Length(matrix[i])]));

  Readln;
end.
