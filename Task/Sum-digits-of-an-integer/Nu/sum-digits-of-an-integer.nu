def digits [r: int] {
  generate {|n| if $n < $r { {out: $n} } else {out: ($n mod $r) next: ($n // $r)} } $in
}

[[0 2] [1 10] [1234 10] [0xfe 16] [0xf0e 16]] | each {|p| $p.0 | digits $p.1 | math sum }
