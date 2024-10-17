def 'seq fibonacci' [] {
  generate { {out: $in.0, next: [$in.1 ($in | math sum)]} } [0 1]
}

seq fibonacci | get 7
