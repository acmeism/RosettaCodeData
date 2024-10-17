function BinarySearch(a: array of integer; x: integer): integer;
begin
  var (l,r) := (0, a.Length-1);
  repeat
    var mid := (l + r) div 2;
    if x = a[mid] then
    begin
      Result := mid;
      exit
    end;
    if x > a[mid] then
      l := mid + 1
    else r := mid - 1;
  until l > r;
  Result := -1;
end;

function BinarySearchRecursive(a: array of integer; x: integer): integer;
  function BinarySearchHelper(a: array of integer; x: integer; l,r: integer): integer;
  begin
    if l > r then
      Result := -1
    else begin
      var mid := (l + r) div 2;
      if x = a[mid] then
        Result := mid
      else if x < a[mid] then
        Result := BinarySearchHelper(a, x, l, mid - 1)
      else Result := BinarySearchHelper(a, x, mid + 1, r)
    end;
  end;
begin
  Result := BinarySearchHelper(a,x,0,a.Length-1);
end;

begin
  var a := ArrRandomInteger(10,1,20);
  a.Sort;
  a.Println;
  var x := 10;
  var ind := BinarySearch(a,x);
  if ind >= 0 then
    Println($'{x} found at index {ind}')
  else Println($'{x} not found');

  ind := BinarySearchRecursive(a,x);
  if ind >= 0 then
    Println($'{x} found at index {ind}')
  else Println($'{x} not found');

  x := a.RandomElement;
  ind := BinarySearch(a,x);
  if ind >= 0 then
    Println($'{x} found at index {ind}')
  else Println($'{x} not found');

  ind := BinarySearchRecursive(a,x);
  if ind >= 0 then
    Println($'{x} found at index {ind}')
  else Println($'{x} not found');
end.
