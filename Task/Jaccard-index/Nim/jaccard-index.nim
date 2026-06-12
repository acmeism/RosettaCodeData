import std/[rationals, strformat]

type Set8 = set[int8]

const
  A: Set8 = {}
  B: Set8 = {1, 2, 3, 4, 5}
  C: Set8 = {1, 3, 5, 7, 9}
  D: Set8 = {2, 4, 6, 8, 10}
  E: Set8 = {2, 3, 5, 7}
  F: Set8 = {8}

  List = [('A', A), ('B', B), ('C', C), ('D', D), ('E', E), ('F', F)]

func J(a, b: Set8): Rational[int] =
  ## Return the Jaccard index.
  ## Return 1 if both sets are empty.
  let card1 = card(a * b)
  let card2 = card(a + b)
  result = if card1 == card2: 1 // 1 else: card1 // card2

for i in 0..List.high:
  let (name1, set1) = List[i]
  for j in i..List.high:
    let (name2, set2) = List[j]
    echo &"J({name1}, {name2}) = {J(set1, set2)}"
    if i != j:
      echo &"J({name2}, {name1}) = {J(set2, set1)}"
