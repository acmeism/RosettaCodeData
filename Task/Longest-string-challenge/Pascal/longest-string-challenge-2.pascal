program LongestStringChallenge_2(input, output);

{$mode ObjFPC}
{$rangechecks on}

uses
  SysUtils;

var
  Line: ANSIstring;
  Lines: array of ANSIstring;
  position: integer;
  tester: char;

begin
  if not eoln(input) then
  begin
    readln (line);
    position := 0;
    setlength(lines, 1);
    lines[0] := line;
    while not eoln(input) do
    begin
      readln (line);
      try
        tester := lines[0][length(line)];
	try
	  tester := line[length(lines[0])];
	  inc(position);
	  setlength(lines, succ(position));
	  lines[position] := line;
	except
	end;
      except
        position := 0;
        setlength(lines, 1);
        lines[0] := line;
      end;
    end;
    for position := low(lines) to high(lines) do
      writeln (lines[position]);
  end;
end.
