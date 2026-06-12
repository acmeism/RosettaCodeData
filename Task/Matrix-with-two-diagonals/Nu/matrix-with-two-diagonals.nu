def diag2 [n: int] {
  1..$n | zip $n..1 | each {|p| seq 1 $n | each { $in in $p | into int } | str join ' ' } | str join "\n"
}

..5 | each { {k: $in v: (diag2 $in)} } | transpose -r
