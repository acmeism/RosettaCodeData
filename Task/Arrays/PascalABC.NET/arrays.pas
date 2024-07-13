begin
  // Static old-style arrays
  var a: array [1..3] of integer := (1,2,3);
  Println(a[1]);

  // dynamic arrays - zero based indices
  var a1: array of integer := new integer[3](1,3,5);
  Println(a1[0]);

  // dynamic arrays
  var a2 := |1,3,5|; // literal array
  SetLength(a2,4);
  a2[^1] := 7;       // "push" new value; ^1 - the first element from the end

  // Lists are dynamically resizing arrays
  var lst := new List<integer>(a1);
  lst.Add(7);
  Println(lst[^1]);
end.
