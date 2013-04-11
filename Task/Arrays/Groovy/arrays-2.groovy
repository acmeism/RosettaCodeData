def identity = { n ->
   (1..n).collect { i -> (1..n).collect { j -> i==j ? 1.0 : 0.0 } }
}
