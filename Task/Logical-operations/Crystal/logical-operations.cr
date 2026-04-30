def show_logical_ops (a, b)
  printf "%-5s && %-5s -> %s\n", a, b, a && b
  printf "%-5s || %-5s -> %s\n", a, b, a || b
  printf "!%-5s         -> %s\n", a, !a
end

show_logical_ops false, true
