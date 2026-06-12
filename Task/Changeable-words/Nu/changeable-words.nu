let pairs = {
  match $in {
    [$top ..$tail] if ($tail | is-not-empty) => {
      out: ($tail | where ($top | str distance $it) == 1 | each { {A: $top B: $in} })
      next: $tail
    }
  }
}

open 'unixdict.txt' | split words -l 12 | generate $pairs $in | flatten | collect
