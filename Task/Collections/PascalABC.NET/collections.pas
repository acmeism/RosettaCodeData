begin
  // build-in array
  var a: array of integer := new integer[5] (1,2,3,4,5);
  // build-in multidimensional array
  var aa: array [,] of integer := new integer[4,3]((1,2,3),(4,5,6),(7,8,9),(1,2,3));
  // List is a resizable array
  var lst := new List<integer>(a);
  lst.Add(1);
  lst.AddRange(|2,3|);
  // HashSet is an unordered set, SortedSet is ordered
  var hs := new HashSet<integer>;
  var ss := new SortedSet<integer>;
  hs.Add(1); ss.Add(2);
  // Dictionary is an unordered map, SortedDictionary is ordered
  var d := new Dictionary<string,integer>;
  d['str1'] := 1; d['str2'] := 3;
  var sd := new SortedDictionary<string,integer>;
  sd['str1'] := 1; sd['str2'] := 3;

  // Stack and Queue
  var s := new Stack<integer>;
  s.Push(1); s.Push(2); s.Push(3);
  var q := new Queue<integer>;
  q.Enqueue(1); q.Enqueue(2); q.Enqueue(3);
end.
