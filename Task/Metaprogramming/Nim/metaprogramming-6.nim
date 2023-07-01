template log(msg: string) =
  if debug:
    echo msg

for i in 1..10:
  log expensive()
