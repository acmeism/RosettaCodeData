// Creates and initializes a new integer Array
var
    // Dynamics arrays can be initialized, if it's global variable in declaration scope
    intArray: TArray<Integer> = [1, 2, 3, 4, 5];
    intArray2: array of Integer = [1, 2, 3, 4, 5];

    //Cann't initialize statics arrays in declaration scope
    intArray3: array [0..4]of Integer;
    intArray4: array [10..14]of Integer;

procedure
var
    // Any arrays can't be initialized, if it's local variable in declaration scope
    intArray5: TArray<Integer>;
begin
  // Dynamics arrays can be full assigned in routine scope
  intArray := [1,2,3];
  intArray2 := [1,2,3];

  // Dynamics arrays zero-based
  intArray[0] := 1;

  // Dynamics arrays must set size, if it not was initialized before
  SetLength(intArray,5);

  // Inline dynamics arrays can be created and initialized routine scope
  // only for version after 10.3 Tokyo
  var intArray6 := [1, 2, 3];
  var intArray7: TArray<Integer> := [1, 2, 3];
end;
