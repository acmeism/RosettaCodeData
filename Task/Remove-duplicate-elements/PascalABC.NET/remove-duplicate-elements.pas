begin
  // By algorithm
  var nums := Arr(1, 1, 2, 3, 4, 4);
  var unique := new List<integer>;
  foreach var x in nums do
    if x not in unique then
      unique.Add(x);
  unique.Println;

  // By method
  var unique2 := nums.Distinct;
  unique2.Println;

  // Using hash set
  var unique3 := HSet(nums);
  unique3.Println;
end.
