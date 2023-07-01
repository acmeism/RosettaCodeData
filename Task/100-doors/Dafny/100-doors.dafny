datatype Door = Closed | Open

method InitializeDoors(n:int) returns (doors:array<Door>)
  // Precondition: n must be a valid array size.
  requires n >= 0
  // Postcondition: doors is an array, which is not an alias for any other
  // object, with a length of n, all of whose elements are Closed. The "fresh"
  // (non-alias) condition is needed to allow doors to be modified by the
  // remaining code.
  ensures doors != null && fresh(doors) && doors.Length == n
  ensures forall j :: 0 <= j < doors.Length ==> doors[j] == Closed;
{
  doors := new Door[n];
  var i := 0;
  // Invariant: i is always a valid index inside the loop, and all doors less
  // than i are Closed. These invariants are needed to ensure the second
  // postcondition.
  while i < doors.Length
    invariant i <= doors.Length
    invariant forall j :: 0 <= j < i ==> doors[j] == Closed;
  {
    doors[i] := Closed;
    i := i + 1;
  }
}

method Main ()
{
  var doors := InitializeDoors(100);

  var pass := 1;
  while pass <= doors.Length
  {
    var door := pass;
    while door < doors.Length
    {
      doors[door] := if doors[door] == Closed then Open else Closed;
      door := door + pass;
    }
    pass := pass + 1;
  }
  var i := 0;
  while i < doors.Length
  {
    print i, " is ", if doors[i] == Closed then "closed\n" else "open\n";
    i := i + 1;
  }
}
