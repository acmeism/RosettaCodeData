tests =
  {"Ignoring leading spaces" =>
  [ "ignore leading spaces: 2-2 ",  " ignore leading spaces: 2-1 ",  "  ignore leading spaces: 2+0 ",  "   ignore leading spaces: 2+1 "],
  "Ignoring multiple adjacent spaces" =>
  [ "ignore m.a.s spaces: 2-2 ",  "ignore m.a.s  spaces: 2-1 ",  "ignore m.a.s   spaces: 2+0 ",  "ignore m.a.s    spaces: 2+1 "],
  "Equivalent whitespace characters" =>
  ["Equiv. spaces: 3-3", "Equiv.\rspaces: 3-2", "Equiv.\x0cspaces: 3-1", "Equiv.\x0bspaces: 3+0", "Equiv.\nspaces: 3+1", "Equiv.\tspaces: 3+2"],
  "Case Indepenent sort" =>
  [ "cASE INDEPENENT: 3-2 ",  "caSE INDEPENENT: 3-1 ",  "casE INDEPENENT: 3+0 ",  "case INDEPENENT: 3+1 "],
  "Numeric fields as numerics" =>
  [ "foo100bar99baz0.txt ",  "foo100bar10baz0.txt ",  "foo1000bar99baz10.txt ",  "foo1000bar99baz9.txt "],
  "Title sorts" =>
  [ "The Wind in the Willows ",  "The 40th step more ",  "The 39 steps ",  "Wanda "]}

tests.each do |title, ar|
  nat_sorts = ar.map{|s| NatSortString.new(s)}
  puts [title,"--input--", ar, "--normal sort--", ar.sort, "--natural sort--", nat_sorts.sort, "\n"]
end
