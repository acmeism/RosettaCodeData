procedure bubbleSort<T>(a: array of T); where T: IComparable<T>;
begin
  var swapped: boolean;
  repeat
    swapped := False;
    for var i := 0 to a.Count - 2 do
      if a[i].CompareTo(a[i + 1]) > 0 then
      begin
        swap(a[i], a[i + 1]);
        swapped := True;
      end;
  until not swapped;
end;

begin
  var a := |4, 65, 2, -31, 0, 99, 2, 83, 782|;
  bubbleSort(a);
  writeln(a);
  var b := 'gcdbafeb'.toarray;
  bubblesort(b);
  writeln(b);
end.
