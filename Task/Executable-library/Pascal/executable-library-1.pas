uses
  DynLibs;
type
  THailSeq = record
    Data: PCardinal;
    Count: Longint;
  end;
var
  Buffer: array[0..511] of Cardinal;

function Hailstone(aValue: Cardinal): THailSeq;
var
  I: Longint;
begin
  Hailstone.Count := 0;
  Hailstone.Data := nil;
  if (aValue <> 0) and (aValue <= 200000) then begin
    Buffer[0] := aValue;
    I := 1;
    repeat
      if Odd(aValue) then
        aValue := Succ((3 * aValue))
      else
        aValue := aValue div 2;
      Buffer[I] := aValue;
      Inc(I);
    until aValue = 1;
    Hailstone.Count := I;
    Hailstone.Data := @Buffer;
  end;
end;

procedure PrintArray(const Prefix: string; const a: array of Cardinal);
var
  I: Longint;
begin
  Write(Prefix, '[');
  for I := 0 to High(a) - 1 do Write(a[I], ', ');
  WriteLn(a[High(a)], ']');
end;

exports
  Hailstone;
var
  hs: THailSeq;
  I, Value: Cardinal;
  MaxLen: Longint;
begin
  hs := Hailstone(27);
  WriteLn('Length of Hailstone(27) is ', hs.Count, ',');
  PrintArray('it starts with ', hs.Data[0..3]);
  PrintArray('and ends with  ', hs.Data[hs.Count-4..hs.Count-1]);
  Value := 0;
  MaxLen := 0;
  for I := 1 to 100000 do begin
    hs := Hailstone(I);
    if hs.Count > MaxLen then begin
      MaxLen := hs.Count;
      Value := I;
    end;
  end;
  WriteLn('Maximum length ', MaxLen, ' was found for Hailstone(', Value, ')');
end.
