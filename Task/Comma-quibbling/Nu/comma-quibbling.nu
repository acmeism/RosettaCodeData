def quibble [] {
  if ($in | length) < 3 { $in } else [($in | drop | str join ', ') ($in | last)]
  | $'{($in | str join " and ")}'
}

# test
[
  []
  [ABC]
  [ABC DEF]
  [ABC DEF G H]
]
| each { quibble }
