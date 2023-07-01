program LongestStringChallenge_1(input, output);

var
  Line: string;
  Lines: array of string;
  position, len: integer;

begin
  if not eoln(input) then
  begin
    len := 1;
    position := 0;
    readln (line);
    setlength(lines, len);
    lines[position] := line;
    while not eoln(input) do
    begin
      readln (line);
      if length(line) = length(lines[0]) then
      begin
        inc(position);
        inc(len);
        setlength(lines, len);
        lines[position] := line;
      end;
      if length(line) > length(lines[0]) then
      begin
        position := 0;
        len := 1;
        setlength(lines, 1);
        lines[0] := line;
      end;
    end;
    for position := low(lines) to high(lines) do
      writeln (lines[position]);
  end;
end.
