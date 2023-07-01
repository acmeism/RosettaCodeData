import strutils

# Requires 5 bytes of data store.
const Hw = r"""
/++++!/===========?\>++.>+.+++++++..+++\
\+++\ | /+>+++++++>/ /++++++++++<<.++>./
$+++/ | \+++++++++>\ \+++++.>.+++.-----\
      \==-<<<<+>+++/ /=.>.+>.--------.-/"""

#---------------------------------------------------------------------------------------------------

proc snusp(dsLen: int; code: string) =
  ## The interpreter.

  var
    ds = newSeq[byte](dsLen)  # Data store.
    dp = 0                    # Data pointer.
    cs = code.splitLines()    # Two dimensional code store.
    ipr, ipc = 0              # Instruction pointers in row ans column.
    dir = 0                   # Direction (0 = right, 1 = down, 2 = left, 3 = up).

  # Initialize instruction pointers.
  for r, row in cs:
    ipc = row.find('$')
    if ipc >= 0:
      ipr = r
      break

  #.................................................................................................

  func step() =
    ## Update the instruction pointers acccording to the direction.

    if (dir and 1) == 0:
      inc ipc, 1 - (dir and 2)
    else:
      inc ipr, 1 - (dir and 2)

  #.................................................................................................

  # Interpreter loop.
  while ipr in 0..cs.high and ipc in 0..cs[ipr].high:
    case cs[ipr][ipc]
    of '>': inc dp
    of '<': dec dp
    of '+': inc ds[dp]
    of '-': dec ds[dp]
    of '.': stdout.write chr(ds[dp])
    of ',': ds[dp] = byte(stdin.readLine()[0])
    of '/': dir = not dir
    of '\\': dir = dir xor 1
    of '!': step()
    of '?': (if ds[dp] == 0: step())
    else: discard
    step()

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:
  snusp(5, Hw)
