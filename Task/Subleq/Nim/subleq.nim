import streams

type
  Interpreter = object
    mem: seq[int]
    ip: int
    input, output: Stream

proc load(prog: openArray[int]; inp, outp: Stream): Interpreter =
  Interpreter(mem: prog, input: inp, output: outp)

proc run(i: var Interpreter) =
  while i.ip >= 0:
    let A = i.mem[i.ip]
    let B = i.mem[i.ip+1]
    let C = i.mem[i.ip+2]
    i.ip += 3
    if A == -1:
      i.mem[B] = ord(i.input.readChar)
    elif B == -1:
      i.output.write(chr(i.mem[A]))
    else:
      i.mem[B] -= i.mem[A]
      if i.mem[B] <= 0:
        i.ip = C

let test = @[15, 17, -1, 17, -1, -1, 16, 1, -1, 16, 3, -1, 15, 15, 0, 0, -1,
             72, 101, 108, 108, 111, 44, 32, 119, 111, 114, 108, 100, 33, 10, 0]
var intr = load(test, newFileStream(stdin), newFileStream(stdout))

try:
  intr.run()
except IndexDefect:
  echo "ip: ", intr.ip
  echo "mem: ", intr.mem
