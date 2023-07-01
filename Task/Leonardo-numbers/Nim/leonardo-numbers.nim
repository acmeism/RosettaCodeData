import strformat

proc leonardoNumbers(count: int, L0: int = 1,
                     L1: int = 1, ADD: int = 1) =
  var t = 0
  var (L0_loc, L1_loc) = (L0, L1)
  for i in 0..<count:
    write(stdout, fmt"{L0_loc:7}")
    t = L0_loc + L1_loc + ADD
    L0_loc = L1_loc
    L1_loc = t
    if i mod 5 == 4:
      write(stdout, "\n")
  write(stdout, "\n")

echo "Leonardo Numbers:"
leonardoNumbers(25)
echo "Fibonacci Numbers: "
leonardoNumbers(25, 0, 1, 0)
