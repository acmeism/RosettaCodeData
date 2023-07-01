program CombSortDemo;


// NOTE: The array is 0-based
//       If you want to use this code on a 1-based array, see above
type
  TIntArray = array[0..39] of integer;

var
  data: TIntArray;
  i: integer;

procedure combSort(var a: TIntArray);
  var
    i, gap, temp: integer;
    swapped: boolean;
  begin
    gap := length(a);
    swapped := true;
    while (gap > 1) or swapped do
    begin
      gap := trunc(gap / 1.3);
      if (gap < 1) then
        gap := 1;
      swapped := false;
      for i := 0 to length(a) - gap - 1 do
        if a[i] > a[i+gap] then
        begin
	  temp := a[i];
          a[i] := a[i+gap];
          a[i+gap] := temp;
          swapped := true;
        end;
    end;
  end;

begin
  Randomize;
  writeln('The data before sorting:');
  for i := low(data) to high(data) do
  begin
    data[i] := Random(high(data));
    write(data[i]:4);
  end;
  writeln;
  combSort(data);
  writeln('The data after sorting:');
  for i := low(data) to high(data) do
  begin
    write(data[i]:4);
  end;
  writeln;
end.
