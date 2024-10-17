def 'str entropy' [] {
  split chars | do {|len|
    (uniq -c).count
    | each { ($in | math log 2) * $in }
    | math sum
    | ($len | math log 2) - $in / $len
  } ($in | length)
}

'1223334444' | str entropy
