l, u, p = a.lup_decomposition
l.pretty_print(" %8.5f", "L")
u.pretty_print(" %8.5f", "U")
p.pretty_print(" %d",    "P")
