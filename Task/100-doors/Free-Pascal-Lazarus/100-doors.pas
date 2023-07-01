program OneHundredIsOpen;

const
  DoorCount = 100;

var
  IsOpen: array[1..DoorCount] of boolean;
  Door, Jump: integer;

begin
  // Close all doors
  for Door := 1 to DoorCount do
    IsOpen[Door] := False;
  // Iterations
  for Jump := 1 to DoorCount do
  begin
    Door := Jump;
    repeat
      IsOpen[Door] := not IsOpen[Door];
      Door := Door + Jump;
    until Door > DoorCount;
  end;
  // Show final status
  for Door := 1 to DoorCount do
  begin
    Write(Door, ' ');
    if IsOpen[Door] then
      WriteLn('open')
    else
      WriteLn('closed');
  end;
  // Wait for <enter>
  Readln;
end.
