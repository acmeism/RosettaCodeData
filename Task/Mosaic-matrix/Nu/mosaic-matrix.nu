def mosaic [n] {
  0..<$n | each {|i| seq 1 $n | bits xor $i | bits and 1 | str join ' ' } | str join "\n"
}

..5 | each { { k: $in v: (mosaic $in) } } | transpose -r
