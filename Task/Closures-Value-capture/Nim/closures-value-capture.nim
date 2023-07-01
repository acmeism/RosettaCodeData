var funcs: seq[proc(): int] = @[]

for i in 0..9:
  (proc =
    let x = i
    funcs.add(proc (): int = x * x))()

for i in 0..8:
  echo "func[", i, "]: ", funcs[i]()
