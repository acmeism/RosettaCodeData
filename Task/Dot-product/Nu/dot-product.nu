def 'math dot' [v] {
  zip $v | each { math product } | math sum
}

[1 3 -5] | math dot [4 -2 -1]
