let $digits = {|q|
  if $q.0.0 < 100 {
    1..9 | each { [($q.0.0 * 10 + $in) ($q.0.1 ++ $in)] } | prepend $q
  } else $q
  | skip
  | if ($in | is-not-empty) { {out: $in.0 next: $in} }
}

generate $digits [[0 []]]
| where ($it.1 | all { $it.0 mod $in == 0 }) and $it.0 mod ($it.1 | math product) > 0
| each { first }
| str join ' '
