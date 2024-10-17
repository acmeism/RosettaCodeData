def 'list lt' [b] {
  let a = $in
  $a | zip $b
  | skip while { $in.0 == $in.1 }
  | try { first } catch { [$a $b] | each { length } }
  | $in.0 < $in.1
}

[5 6 7 8] | list lt [5 6 8]
