def 'str is-ordered' [] {
  split chars | window 2 | all { $in.0 <= $in.1 }
}

open 'unixdict.txt' | lines
| group-by { str length } | sort -n -r
| values | each { filter { str is-ordered } }
| skip while { is-empty } | first
