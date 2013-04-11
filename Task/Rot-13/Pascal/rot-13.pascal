program rot13(input, output);

function rot13(someText: string): string;
var
  i: integer;
  ch: char;
  resultText: string = '';

begin
  for i := 1 to Length(someText) do begin
    ch := someText[i];
    case ch  of
      'A' .. 'M', 'a' .. 'm': ch := chr(ord(ch)+13);
      'N' .. 'Z', 'n' .. 'z': ch := chr(ord(ch)-13)
    end;
    resultText := resultText + ch
  end;
  rot13 := resultText
end;

var
  line: string;

begin
  while not eof(input) do begin
    readln(line);
    writeln(rot13(line))
  end
end.
