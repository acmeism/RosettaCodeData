begin
  var lines := ReadLines('data.csv').Select((line,i) -> begin
    if i = 0 then
      Result := line + ',SUM'
    else Result := line + ',' + line.Split(',').Sum(x -> x.ToInteger);
  end);
  WriteLines('outdata.csv',lines);
  lines.PrintLines;
end.
