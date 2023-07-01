proc print(xs: varargs[string, `$`]) =
  for x in xs:
    echo x
