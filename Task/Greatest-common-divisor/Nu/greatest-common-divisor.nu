def 'math gcd' [] {
  reduce {|x gcd|
    generate { match $in { [$a 0] => {out: $a} [$a $b] => {next: [$b ($a mod $b)]} } } [$x $gcd]
    | first
  }
}

[63 18 45] | math gcd
