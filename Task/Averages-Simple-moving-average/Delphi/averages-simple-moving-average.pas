program Simple_moving_average;

{$APPTYPE CONSOLE}

type
  TMovingAverage = record
  private
    buffer: TArray<Double>;
    head: Integer;
    Capacity: Integer;
    Count: Integer;
    sum, fValue: Double;
  public
    constructor Create(aCapacity: Integer);
    function Add(Value: Double): Double;
    procedure Reset;
    property Value: Double read fValue;
  end;

{ TMovingAverage }

function TMovingAverage.Add(Value: Double): Double;
begin
  head := (head + 1) mod Capacity;
  sum := sum + Value - buffer[head];
  buffer[head] := Value;

  if count < capacity then
  begin
    inc(Count);
    fValue := sum / count;
    exit(fValue);
  end;
  fValue := sum / Capacity;
  Result := fValue;
end;

constructor TMovingAverage.Create(aCapacity: Integer);
begin
  Capacity := aCapacity;
  SetLength(buffer, aCapacity);
  Reset;
end;

procedure TMovingAverage.Reset;
var
  i: integer;
begin
  head := -1;
  Count := 0;
  sum := 0;
  fValue := 0;
  for i := 0 to High(buffer) do
    buffer[i] := 0;
end;

var
  avg3, avg5: TMovingAverage;
  i: Integer;

begin
  avg3 := TMovingAverage.Create(3);
  avg5 := TMovingAverage.Create(5);

  for i := 1 to 5 do
  begin
    write('Inserting ', i, ' into avg3 ', avg3.Add(i): 0: 4);
    writeln(' Inserting ', i, ' into avg5 ', avg5.Add(i): 0: 4);
  end;

  for i := 5 downto 1 do
  begin
    write('Inserting ', i, ' into avg3 ', avg3.Add(i): 0: 4);
    writeln(' Inserting ', i, ' into avg5 ', avg5.Add(i): 0: 4);
  end;

  avg3.Reset;
  for i := 1 to 100000000 do
    avg3.Add(i);
  writeln('100''000''000 insertions ', avg3.Value: 0: 4);

  Readln;
end.
