# To print all the solutions:
# solve | pp

# To count the number of solutions:
# count(solve)

# jq 1.4 lacks facilities for harnessing generators,
# but the following will suffice here:
def one(f): reduce f as $s
  (null; if . == null then $s else . end);

one(solve) | pp
