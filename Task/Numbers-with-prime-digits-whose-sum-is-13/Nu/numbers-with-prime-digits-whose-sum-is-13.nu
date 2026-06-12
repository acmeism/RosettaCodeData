generate {
  match $in {
    [[ 0 $n] ..$q] => {next: $q out: $n}
    [[$r $n] ..$q] => {next:
      ([2 3 5 7] | take until { $in > $r } | each { [($r - $in) ($n * 10 + $in)] } | prepend $q)
    }
  }
} [[13 0]]
| str join ' '
