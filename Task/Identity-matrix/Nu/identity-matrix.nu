def identity-matrix [n: int] {
  ..<$n | each {|i| ..<$n | each { $in == $i | into int } }
}

..5 | each { {k: $in v: (identity-matrix $in)} } | transpose -r | table -i false -e --flatten
