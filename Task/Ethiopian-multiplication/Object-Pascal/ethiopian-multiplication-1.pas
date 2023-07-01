unit Multiplication;
interface

function Double(Number: Integer): Integer;
function Halve(Number: Integer): Integer;
function Even(Number: Integer): Boolean;
function Ethiopian(NumberA, NumberB: Integer): Integer;

implementation
  function Double(Number: Integer): Integer;
  begin
    result := Number * 2
  end;

  function Halve(Number: Integer): Integer;
  begin
    result := Number div 2
  end;

  function Even(Number: Integer): Boolean;
  begin
    result := Number mod 2 = 0
  end;

  function Ethiopian(NumberA, NumberB: Integer): Integer;
  begin
    result := 0;
    while NumberA >= 1 do
    begin
      if not Even(NumberA) then
        result := result + NumberB;
      NumberA := Halve(NumberA);
      NumberB := Double(NumberB)
    end
  end;
begin
end.
