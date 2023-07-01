program HQ9;

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
      'Q','q':
        writeln(code);
      'H','h':
        Writeln('Hello, world!');
      '9':
        begin
          bottles := 99;
          repeat
            writeln(bottles,' bottles of beer on the wall');
            writeln(bottles,' bottles of beer');
            Writeln('Take one down, pass it around');
            dec(bottles);
            writeln(bottles,' bottles of beer on the wall',#13#10);
          until (bottles <= 0);
        end;
      '+':
        inc(accumulator);
    end;
  end;
end;
BEGIN
  runCode('QqQh');
  //runCode('HQ9+');// output to long
END.
