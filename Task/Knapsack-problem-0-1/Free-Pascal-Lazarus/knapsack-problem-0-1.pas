program Knapsack01;
{$mode objfpc}{$j-}
uses
  Math;

type
  TItem = record
    Name: string;
    Weight, Value: Integer;
  end;

const
  NUM_ITEMS = 22;
  ITEMS: array[0..NUM_ITEMS-1] of TItem = (
    (Name: 'map';                    Weight:   9; Value: 150),
    (Name: 'compass';                Weight:  13; Value:  35),
    (Name: 'water';                  Weight: 153; Value: 200),
    (Name: 'sandwich';               Weight:  50; Value: 160),
    (Name: 'glucose';                Weight:  15; Value:  60),
    (Name: 'tin';                    Weight:  68; Value:  45),
    (Name: 'banana';                 Weight:  27; Value:  60),
    (Name: 'apple';                  Weight:  39; Value:  40),
    (Name: 'cheese';                 Weight:  23; Value:  30),
    (Name: 'beer';                   Weight:  52; Value:  10),
    (Name: 'suntan cream';           Weight:  11; Value:  70),
    (Name: 'camera';                 Weight:  32; Value:  30),
    (Name: 'T-shirt';                Weight:  24; Value:  15),
    (Name: 'trousers';               Weight:  48; Value:  10),
    (Name: 'umbrella';               Weight:  73; Value:  40),
    (Name: 'waterproof trousers';    Weight:  42; Value:  70),
    (Name: 'waterproof overclothes'; Weight:  43; Value:  75),
    (Name: 'note-case';              Weight:  22; Value:  80),
    (Name: 'sunglasses';             Weight:   7; Value:  20),
    (Name: 'towel';                  Weight:  18; Value:  12),
    (Name: 'socks';                  Weight:   4; Value:  50),
    (Name: 'book';                   Weight:  30; Value:  10)
  );
  MAX_WEIGHT = 400;

var
  D: array of array of Integer;
  I, W, V, MaxWeight: Integer;
begin
  SetLength(D, NUM_ITEMS + 1, MAX_WEIGHT + 1);
  for I := 0 to High(ITEMS) do
    for W := 0 to MAX_WEIGHT do
      if ITEMS[I].Weight > W then
        D[I+1, W] := D[I, W]
      else
        D[I+1, W] := Max(D[I, W], D[I, W - ITEMS[I].Weight] + ITEMS[I].Value);

  W := MAX_WEIGHT;
  V := D[NUM_ITEMS, W];
  MaxWeight := 0;
  WriteLn('bagged:');
  for I := High(ITEMS) downto 0 do
    if (D[I+1, W] = V)and(D[I, W - ITEMS[I].Weight] = V - ITEMS[I].Value)then begin
      WriteLn('  ', ITEMS[I].Name);
      Inc(MaxWeight, ITEMS[I].Weight);
      Dec(W, ITEMS[I].Weight);
      Dec(V, ITEMS[I].Value);
    end;
  WriteLn('value  = ', D[NUM_ITEMS, MAX_WEIGHT]);
  WriteLn('weight = ', MaxWeight);
end.
