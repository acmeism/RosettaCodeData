var schwartzian = Fn.new { |a, f|
    System.print(a.map  { |e| [e, f.call(e)] }  // decorate
                  .toList
                  .sort { |p, q| p[1] < q[1] }  // sort
                  .map  { |p| "\"%(p[0])\""  }  // undecorate
                  .toList)
}

var words = ["Rosetta", "Code", "is", "a", "programming", "chrestomathy", "site"]
var length = Fn.new { |s| s.count }
schwartzian.call(words, length)
