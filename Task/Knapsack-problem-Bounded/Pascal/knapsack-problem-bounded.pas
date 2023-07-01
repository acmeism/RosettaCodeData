program KnapsackBounded;
{$mode objfpc}{$j-}
uses
  SysUtils, Math;

type
  TItem = record
    Name: string;
    Weight, Value, Count: Integer;
  end;

const
  NUM_ITEMS = 22;
  ITEMS: array[0..NUM_ITEMS-1] of TItem = (
    (Name: 'map';                    Weight:   9; Value: 150; Count: 1),
    (Name: 'compass';                Weight:  13; Value:  35; Count: 1),
    (Name: 'water';                  Weight: 153; Value: 200; Count: 2),
    (Name: 'sandwich';               Weight:  50; Value:  60; Count: 2),
    (Name: 'glucose';                Weight:  15; Value:  60; Count: 2),
    (Name: 'tin';                    Weight:  68; Value:  45; Count: 3),
    (Name: 'banana';                 Weight:  27; Value:  60; Count: 3),
    (Name: 'apple';                  Weight:  39; Value:  40; Count: 3),
    (Name: 'cheese';                 Weight:  23; Value:  30; Count: 1),
    (Name: 'beer';                   Weight:  52; Value:  10; Count: 3),
    (Name: 'suntan cream';           Weight:  11; Value:  70; Count: 1),
    (Name: 'camera';                 Weight:  32; Value:  30; Count: 1),
    (Name: 'T-shirt';                Weight:  24; Value:  15; Count: 2),
    (Name: 'trousers';               Weight:  48; Value:  10; Count: 2),
    (Name: 'umbrella';               Weight:  73; Value:  40; Count: 1),
    (Name: 'waterproof trousers';    Weight:  42; Value:  70; Count: 1),
    (Name: 'waterproof overclothes'; Weight:  43; Value:  75; Count: 1),
    (Name: 'note-case';              Weight:  22; Value:  80; Count: 1),
    (Name: 'sunglasses';             Weight:   7; Value:  20; Count: 1),
    (Name: 'towel';                  Weight:  18; Value:  12; Count: 2),
    (Name: 'socks';                  Weight:   4; Value:  50; Count: 1),
    (Name: 'book';                   Weight:  30; Value:  10; Count: 2)
  );
  MAX_WEIGHT = 400;

var
  D: array of array of Integer; //DP matrix
  I, W, V, C, MaxWeight: Integer;
begin
  SetLength(D, NUM_ITEMS + 1, MAX_WEIGHT + 1);
  for I := 0 to High(ITEMS) do
    for W := 0 to MAX_WEIGHT do begin
      D[I+1, W] := D[I, W];
      for C := 1 to ITEMS[I].Count do begin
        if ITEMS[I].Weight * C > W then break;
        V := D[I, W - ITEMS[I].Weight * C] + ITEMS[I].Value * C;
        if V > D[I+1, W] then
          D[I+1, W] := V;
      end;
    end;

  W := MAX_WEIGHT;
  MaxWeight := 0;
  WriteLn('bagged:');
  for I := High(ITEMS) downto 0 do begin
    V := D[I+1, W];
    C := 0;
    while V <> D[I, W] + ITEMS[I].Value * C do begin
      Dec(W, ITEMS[I].Weight);
      Inc(C);
    end;
    Inc(MaxWeight, C * ITEMS[I].Weight);
    if C <> 0 then
       WriteLn('  ', C, ' ', ITEMS[I].Name);
  end;
  WriteLn('value  = ', D[NUM_ITEMS, MAX_WEIGHT]);
  WriteLn('weight = ', MaxWeight);
end.
