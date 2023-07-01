import os

var
  code = if paramCount() > 0: readFile paramStr 1
         else: readAll stdin
  tape = newSeq[char]()
  d    = 0
  i    = 0

proc run(skip = false): bool =
  while d >= 0 and i < code.len:
    if d >= tape.len: tape.add '\0'

    if code[i] == '[':
      inc i
      let p = i
      while run(tape[d] == '\0'): i = p
    elif code[i] == ']':
      return tape[d] != '\0'
    elif not skip:
      case code[i]
      of '+': inc tape[d]
      of '-': dec tape[d]
      of '>': inc d
      of '<': dec d
      of '.': stdout.write tape[d]
      of ',': tape[d] = stdin.readChar
      else: discard

    inc i

discard run()
