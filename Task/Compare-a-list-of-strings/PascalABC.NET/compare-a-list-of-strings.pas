function AllEqual(lst: sequence of string)
  := lst.All(x -> lst.First = x);

function IsStrictAscending(lst: sequence of string): boolean
  := lst.Pairwise.All(x -> x[0] < x[1]);

begin
  var strings := |'abc','abc','abc','abc'|;
  Print(AllEqual(strings));
  var strings1 := |'abc','abd','ade','aef'|;
  Print(IsStrictAscending(strings1));
end.
