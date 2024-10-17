def jewels [j] {
  split chars | reduce -f 0 {|c, n| $c in $j | into int | $n + $in }
}
