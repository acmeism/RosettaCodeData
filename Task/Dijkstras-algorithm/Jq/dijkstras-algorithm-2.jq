def GRAPH: {
   "a": {"b": 7, "c": 9, "f": 14},
   "b": {"c": 10, "d": 15},
   "c": {"d": 11, "f": 2},
   "d": {"e": 6},
   "e": {"f": 9}
  };

# To produce the final version of the scratchpad:
# GRAPH | Dijkstra("a")

"\nThe shortest paths from a to e and to f:",
(GRAPH | Dijkstra("a"; "e", "f") | .[0])
