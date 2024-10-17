label
  tryAgain, finished;

begin
  x := 0;

  try
    Writeln(x);
    inc(x);
    if (x < 10) then
      goto tryAgain;
  finally
    goto finished
  end;
finished:
  readln;
end.
