var
  matrix: array[1..10,1..10] of Integer;
  row, col: Integer;
  broken: Boolean;
begin
  // Launch random number generator
  randomize;
  // Filling matrix with random numbers
  for row := 1 to 10 do
    for col := 1 to 10 do
      matrix[row, col] := Succ(Random(20));
  // Displaying values one by one, until at the end or reached number 20
  Broken := False;
  for row := 1 to 10 do
  begin
    for col := 1 to 10 do
    begin
      ShowMessage(IntToStr(matrix[row, col]));
      if matrix[row, col] = 20 then
      begin
        Broken := True;
        break;
      end;
    end;
    if Broken then break;
  end;
end;
