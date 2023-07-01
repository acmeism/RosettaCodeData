import strformat

for i in 0..15:
  for j in countup(32 + i, 127, step = 16):
    let k = case j
            of 32: "Spc"
            of 127: "Del"
            else: $chr(j)
    write(stdout, fmt"{j:3d} : {k:<6s}")
  write(stdout, "\n")
