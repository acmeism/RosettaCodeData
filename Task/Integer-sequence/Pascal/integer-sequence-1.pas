Program IntegerSequenceLimited;
var
  Number: QWord = 0; // 8 bytes, unsigned: 0 .. 18446744073709551615
begin
  repeat
    writeln(Number);
    inc(Number);
  until false;
end.
