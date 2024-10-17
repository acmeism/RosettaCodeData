program Sorting_Algorithms;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function CircleSort(a: TArray<Integer>; lo, hi, swaps: Integer): Integer;
begin
  if lo = hi then
    exit(swaps);

  var high := hi;
  var low := lo;
  var mid := (hi - lo) div 2;

  while lo < hi do
  begin
    if a[lo] > a[hi] then
    begin
      var tmp := a[lo];
      a[lo] := a[hi];
      a[hi] := tmp;
      inc(swaps);
    end;
    inc(lo);
    dec(hi);
  end;

  if lo = hi then
  begin
    if a[lo] > a[hi + 1] then
    begin
      var tmp := a[lo];
      a[lo] := a[hi + 1];
      a[hi + 1] := tmp;
      inc(swaps);
    end;
  end;
  swaps := CircleSort(a, low, low + mid, swaps);
  swaps := CircleSort(a, low + mid + 1, high, swaps);
  result := swaps;
end;

function ToString(a: TArray<Integer>): string;
begin
  Result := '[';
  for var e in a do
    Result := Result + e.ToString + ',';
  Result := Result + ']';
end;

const
  aa: TArray<TArray<Integer>> = [[6, 7, 8, 9, 2, 5, 3, 4, 1], [2, 14, 4, 6, 8, 1,
    3, 5, 7, 11, 0, 13, 12, -1]];

begin
  for var a in aa do
  begin
    write('Original: ');
    write(ToString(a));
    while CircleSort(a, 0, high(a), 0) <> 0 do
      ;
    writeln;
    write('Sorted  : ');
    write(ToString(a));
    writeln(#10#10);
  end;
  readln;
end.
