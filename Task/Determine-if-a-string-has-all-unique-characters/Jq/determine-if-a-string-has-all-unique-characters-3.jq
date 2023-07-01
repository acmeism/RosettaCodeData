header,
  (data
   | firstDuplicate as [$k, $v]
   | "\(q|lpad(38)) : \(length|lpad(4)) : \($k // " ") : \($k |if . then hex else "  " end)   \($v // [])" )
