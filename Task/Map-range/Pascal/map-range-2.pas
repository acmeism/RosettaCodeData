Program Map(output);

type
  real = double;
  tRange = Array [0..1] of real;
  tMapRec = record
              mrFrom,
              mrTo : tRange;
              mrScale : real
            end;

function InitRange(rfrom,rTo:real):tRange;
begin
  InitRange[0] :=rfrom;
  InitRange[1] :=rTo;
end;

function InitMapRec(const fromRange, toRange: tRange):tMapRec;
begin
  With InitMapRec do
  Begin
    mrFrom := fromRange;
    mrTo   := toRange;
    mrScale := (toRange[1]-toRange[0]) / (fromRange[1]-fromRange[0]);
  end;
end;

function MapRecRange(const value: real;var MR :tMapRec): real;
begin
  with MR do
    MapRecRange := (value-mrFrom[0]) * mrScale + mrTo[0];
end;

function MapRange(const value: real;const fromRange, toRange: tRange): real;
begin
  MapRange := (value-fromRange[0]) * (toRange[1]-toRange[0]) / (fromRange[1]-fromRange[0]) + toRange[0];
end;

var
  value:real;
  rFrom,rTo : tRange;
  mr : tMapRec;
  i: LongInt;

begin
  rFrom:= InitRange(  0, 10);
  rTo  := InitRange( -1,  0);
  mr:= InitMapRec(rFrom,rTo);

  for i := 0 to 10 do
  Begin
    value := i;
    writeln (i:4, ' maps to: ', MapRange(value,rFrom, rTo):10:6,
                                  MapRecRange(value,mr):10:6);
  end;
end.
