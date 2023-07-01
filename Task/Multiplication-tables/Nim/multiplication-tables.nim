import strfmt

const n = 12

for j in 1..n:
  stdout.write "{:3d}{:s}".fmt(j, if n-j>0: " " else: "\n")
for j in 0..n:
  stdout.write if n-j>0: "----" else: "+\n"
for i in 1..n:
  for j in 1..n:
    stdout.write if j<i: "    " else: "{:3d} ".fmt(i*j)
  echo "| {:2d}".fmt(i)
