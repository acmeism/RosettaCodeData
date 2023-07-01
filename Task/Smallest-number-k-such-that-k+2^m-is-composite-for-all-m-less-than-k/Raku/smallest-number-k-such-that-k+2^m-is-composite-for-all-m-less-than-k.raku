put (1..∞).hyper(:250batch).map(* × 2 + 1).grep( -> $k { !(1 ..^ $k).first: ($k + 1 +< *).is-prime } )[^5]
