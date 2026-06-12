const sets = {
  A: []
  B: [1 2 3 4 5]
  C: [1 3 5 7 9]
  D: [2 4 6 8 10]
  E: [2 3 5 7]
  F: [8]
}

def jaccard [v] {
  append $v | uniq -c | each { $in.count - 1 } | try { math avg } catch { 1 }
}

$sets | items {|y v|
  $sets | columns | reduce -f ({index: $y} | merge $sets) {|x row|
    $row | update $x { jaccard $v }
  }
}
