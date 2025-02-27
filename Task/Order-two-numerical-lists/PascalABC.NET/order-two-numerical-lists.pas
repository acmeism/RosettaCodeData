##
function operator <<T>(a, b: List<T>): boolean;
extensionmethod; where T: IComparable<T>;
begin
  foreach var (x, y) in Zip(a, b) do
  begin
    if x = y then continue;
    result := x.CompareTo(y) < 0;
    exit;
  end;
  result := a.Count < b.Count;
end;

println(Lst(1, 2, 1, 3, 2) < Lst(1, 2, 0, 4, 4, 0, 0, 0));
println(Lst(1, 2, 0, 4, 4, 0, 0, 0) < Lst(1, 2, 1, 3, 2));
