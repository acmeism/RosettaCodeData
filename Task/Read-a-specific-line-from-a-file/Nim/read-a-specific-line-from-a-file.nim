import strformat

proc readLine(f: File; num: Positive): string =
  for n in 1..num:
    try:
      result = f.readLine()
    except EOFError:
      raise newException(IOError, &"Not enough lines in file; expected {num}, found {n - 1}.")

let f = open("test.txt", fmRead)
echo f.readLine(7)
f.close()
