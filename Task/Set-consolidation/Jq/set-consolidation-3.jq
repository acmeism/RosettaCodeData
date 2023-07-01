def tests:
  [["A", "B"], ["C","D"]],
  [["A","B"], ["B","D"]],
  [["A","B"], ["C","D"], ["D","B"]],
  [["H","I","K"], ["A","B"], ["C","D"], ["D","B"], ["F","G","H"]]
;

def test:
  tests | to_set | consolidate;

test
