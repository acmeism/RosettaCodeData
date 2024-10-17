uses
  System.SysUtils;

procedure runCode(code: string);
var
  c_len, i, bottles: Integer;
  accumulator: Cardinal;
begin
  c_len := Length(code);
  accumulator := 0;
  for i := 1 to c_len do
  begin
    case code[i] of
      'Q':
        writeln(code);
      'H':
        Writeln('Hello, world!');
      '9':
        begin
          bottles := 99;
          repeat
            writeln(format('%d bottles of beer on the wall', [bottles]));
            writeln(format('%d bottles of beer', [bottles]));
            Writeln('Take one down, pass it around');
            dec(bottles);
            writeln(format('%d bottles of beer on the wall' + sLineBreak, [bottles]));
          until (bottles <= 0);
        end;
      '+':
        inc(accumulator);
    end;
  end;
end;
