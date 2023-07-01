program SubleqTest;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

var
  mem: array of Integer;
  instructionPointer: Integer;
  a, b: Integer;

begin
  mem := [15, 17, -1, 17, -1, -1, 16, 1, -1, 16, 3, -1, 15, 15, 0, 0, -1, 72,
    101, 108, 108, 111, 44, 32, 119, 111, 114, 108, 100, 33, 10, 0];
  instructionPointer := 0;

  repeat
    a := mem[instructionPointer];
    b := mem[instructionPointer + 1];

    if a = -1 then
    begin
      read(mem[b]);
    end
    else if b = -1 then
    begin
      write(ansichar(mem[a]));
    end
    else
    begin
      mem[b] := mem[b] - mem[a];
      if (mem[b] < 1) then
      begin
        instructionPointer := mem[instructionPointer + 2];
        Continue;
      end;
    end;
    inc(instructionPointer, 3);
  until (instructionPointer >= length(mem)) or (instructionPointer < 0);
  readln;
end.
