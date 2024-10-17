def make-row [n] {
  {word: $in decimal: $n dr: (($n - 1) mod 9 + 1)}
}

def fmt-table [] {
  $"($in | table -i false -t compact)total count: ($in | length)\n"
}

open 'unixdict.txt' | split words -l 4
| where $it =~ '(?i)^[A-F]+$'
| each { make-row ($in | into int -r 16) }
| [
    ($in | sort-by dr)
    ($in | where ($it.word | split chars | uniq | length) > 3 | sort-by -r decimal)
  ]
| each { fmt-table } | str join "\n"
