def bigTree:
  ["a",
   ["aa",
    ["aaa",
     ["aaaa"],
     ["aaab",
      ["aaaba"],
      ["aaabb"]],
     ["aaac"]]],
   ["ab"],
   ["ac",
    ["aca"],
    ["acb"],
    ["acc"]]] ;

[0, 1, 2, 3],
[1,[2,3,[4, 5, [6,7,8], 9, [10,11]]]],
bigTree
| ("Tree with array representation:\n\(.)\n",
  printTree,
  "")
