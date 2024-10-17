var
  SudokuSolver: TSudokuSolver;
begin
  SudokuSolver := TSudokuSolver.Create('850002400' +
                                       '720000009' +
                                       '004000000' +
                                       '000107002' +
                                       '305000900' +
                                       '040000000' +
                                       '000080070' +
                                       '017000000' +
                                       '000036040');
  try
    SudokuSolver.Solve;
  finally
    FreeAndNil(SudokuSolver);
  end;
end;
