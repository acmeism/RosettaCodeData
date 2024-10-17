def 'seq rnd-nomal' [mean sdev] {
  0.. | each { random float (-1)..1 } | window 2
  | each { [($in.0 ** 2 + $in.1 ** 2) $in.1] }
  | where { 0 < $in.0 and $in.0 < 1 }
  | each { do {|q r| -2 * ($q | math ln) / $q | math sqrt | $sdev * $in * $r + $mean } ...$in }
}

let rand = seq rnd-nomal 1.0 0.5 | take 1000

$'mean: ($rand | math avg), standard deviation: ($rand | math stddev)'
