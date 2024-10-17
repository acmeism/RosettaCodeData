def 'matrix transpose' [] {
  each { into record } | values
}

[[1 5 9] [2 6 10] [3 7 11] [4 8 12]] | matrix transpose | to nuon
