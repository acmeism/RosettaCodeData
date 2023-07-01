import os, parseutils, strutils, strscans, strformat

type

  Value = int32
  BytesValue = array[4, byte]
  Address = int32

  OpCode = enum
           opFetch = "fetch"
           opStore = "store"
           opPush = "push"
           opJmp = "jmp"
           opJz = "jz"
           opAdd = "add"
           opSub = "sub"
           opMul = "mul"
           opDiv = "div"
           opMod = "mod"
           opLt = "lt"
           opgt = "gt"
           opLe = "le"
           opGe = "ge"
           opEq = "eq"
           opNe = "ne"
           opAnd = "and"
           opOr = "or"
           opNeg = "neg"
           opNot = "not"
           opPrtc = "prtc"
           opPrti = "prti"
           opPrts = "prts"
           opHalt = "halt"
           opInvalid = "invalid"

  # Virtual machine description.
  VM = object
    stack: seq[Value]     # Evaluation stack.
    memory: seq[byte]     # Memory to store program.
    data: seq[Value]      # Data storage.
    strings: seq[string]  # String storage.
    pc: Address           # Program counter.

  # Exceptions.
  LoadingError = object of CatchableError
  RuntimeError = object of CatchableError


####################################################################################################
# Running program.

proc checkStackLength(vm: VM; minLength: int) {.inline.} =
  ## Check that evaluation stack contains at least "minLength" elements.
  if vm.stack.len < minLength:
    raise newException(RuntimeError, &"not enough operands on the stack (pc = {vm.pc}).")

#---------------------------------------------------------------------------------------------------

proc getOperand(vm: var VM): Value =
  ## Get a 32 bits operand.

  type Union {.union.} = object
    value: Value
    bytes: BytesValue

  if vm.pc + 4 >= vm.memory.len:
    raise newException(RuntimeError, &"out of memory (pc = {vm.pc}).")

  var aux: Union
  let address = vm.pc + 1
  for idx in 0..3:
    aux.bytes[idx] = vm.memory[address + idx]
  result = aux.value

#---------------------------------------------------------------------------------------------------

proc run(vm: var VM) =
  ## Run a program loaded in VM memory.

  vm.pc = 0

  while true:

    if vm.pc notin 0..vm.memory.high:
      raise newException(RuntimeError, &"out of memory (pc = {vm.pc}).")

    let opcode = OpCode(vm.memory[vm.pc])
    case opcode

    of opFetch, opStore:
      let index = vm.getOperand()
      if index notin 0..vm.data.high:
        raise newException(RuntimeError, &"wrong memory index (pc = {vm.pc}).")
      if opcode == opFetch:
        vm.stack.add(vm.data[index])
      else:
        vm.checkStackLength(1)
        vm.data[index] = vm.stack.pop()
      inc vm.pc, 4

    of opPush:
      let value = vm.getOperand()
      vm.stack.add(value)
      inc vm.pc, 4

    of opJmp:
      let offset = vm.getOperand()
      inc vm.pc, offset

    of opJz:
      let offset = vm.getOperand()
      vm.checkStackLength(1)
      let value = vm.stack.pop()
      inc vm.pc, if value == 0: offset else: 4

    of opAdd..opOr:
      # Two operands instructions.
      vm.checkStackLength(2)
      let op2 = vm.stack.pop()
      let op1 = vm.stack.pop()
      case range[opAdd..opOr](opcode)
      of opAdd:
        vm.stack.add(op1 + op2)
      of opSub:
        vm.stack.add(op1 - op2)
      of opMul:
        vm.stack.add(op1 * op2)
      of opDiv:
        vm.stack.add(op1 div op2)
      of opMod:
        vm.stack.add(op1 mod op2)
      of opLt:
        vm.stack.add(Value(op1 < op2))
      of opgt:
        vm.stack.add(Value(op1 > op2))
      of opLe:
        vm.stack.add(Value(op1 <= op2))
      of opGe:
        vm.stack.add(Value(op1 >= op2))
      of opEq:
        vm.stack.add(Value(op1 == op2))
      of opNe:
        vm.stack.add(Value(op1 != op2))
      of opAnd:
        vm.stack.add(op1 and op2)
      of opOr:
        vm.stack.add(op1 or op2)

    of opNeg..opPrts:
      # One operand instructions.
      vm.checkStackLength(1)
      let op = vm.stack.pop()
      case range[opNeg..opPrts](opcode)
      of opNeg:
        vm.stack.add(-op)
      of opNot:
        vm.stack.add(not op)
      of opPrtc:
        stdout.write(chr(op))
      of opPrti:
        stdout.write(op)
      of opPrts:
        if op notin 0..vm.strings.high:
          raise newException(RuntimeError, &"wrong string index (pc = {vm.pc}).")
        stdout.write(vm.strings[op])

    of opHalt:
      break

    of opInvalid:
      discard   # Not possible.

    inc vm.pc


####################################################################################################
# Loading assembly file.

proc parseHeader(line: string): tuple[dataSize, stringCount: int] =
  ## Parse the header.

  if not line.scanf("Datasize: $s$i $sStrings: $i", result.dataSize, result.stringCount):
    raise newException(LoadingError, "Wrong header in code.")

#---------------------------------------------------------------------------------------------------

import re

proc parseString(line: string; linenum: int): string =
  ## Parse a string.

  if not line.startsWith('"'):
    raise newException(LoadingError, "Line $1: incorrect string.".format(linenum))
  # Can't use "unescape" as it is confused by "\\n" and "\n".
  result = line.replacef(re"([^\\])(\\n)", "$1\n").replace(r"\\", r"\").replace("\"", "")

#---------------------------------------------------------------------------------------------------

proc parseValue(line: string; linenum: int; pos: var int; msg: string): int32 =
  ## Parse an int32 value.

  var value: int

  pos += line.skipWhitespace(pos)
  let parsed = line.parseInt(value, pos)
  if parsed == 0:
    raise newException(LoadingError, "Line $1: ".format(linenum) & msg)
  pos += parsed
  result = int32(value)

#---------------------------------------------------------------------------------------------------

proc parseOpcode(line: string; linenum: int; pos: var int): OpCode =
  ## Parse an opcode.

  var opstring: string

  pos += line.skipWhitespace(pos)
  let parsed = line.parseIdent(opstring, pos)
  if parsed == 0:
    raise newException(LoadingError, "Line $1: opcode expected".format(linenum))
  pos += parsed

  result = parseEnum[OpCode](opstring, opInvalid)
  if result == opInvalid:
    raise newException(LoadingError, "Line $1: invalid opcode encountered".format(linenum))

#---------------------------------------------------------------------------------------------------

proc parseMemoryIndex(line: string; linenum: int; pos: var int): int32 =
  ## Parse a memory index (int32 value between brackets).

  var memIndex: int

  pos += line.skipWhitespace(pos)
  let str = line.captureBetween('[', ']', pos)
  if str.parseInt(memIndex) == 0 or memIndex < 0:
    raise newException(LoadingError, "Line $1: invalid memory index".format(lineNum))
  pos += str.len + 2
  result = int32(memIndex)

#---------------------------------------------------------------------------------------------------

proc parseOffset(line: string; linenum: int; pos: var int): int32 =
  ## Parse an offset (int32 value between parentheses).

  var offset: int

  pos += line.skipWhitespace(pos)
  let str = line.captureBetween('(', ')', pos)
  if str.parseInt(offset) == 0:
    raise newException(LoadingError, "Line $1: invalid offset".format(linenum))
  pos += str.len + 2
  result = int32(offset)

#---------------------------------------------------------------------------------------------------

proc load(vm: var VM; code: string) =
  ## Load an assembly code into VM memory.

  # Analyze header.
  let lines = code.splitlines()
  let (dataSize, stringCount) = parseHeader(lines[0])
  vm.data.setLen(dataSize)
  vm.strings.setLen(stringCount)

  # Load strings.
  for idx in 1..stringCount:
    vm.strings[idx - 1] = lines[idx].parseString(idx + 1)

  # Load code.
  var pc: Address = 0
  for idx in (stringCount + 1)..lines.high:
    var pos = 0
    let line = lines[idx]
    if line.len == 0: continue

    # Process address.
    let address = line.parseValue(idx + 1, pos, "address expected")
    if address != pc:
      raise newException(LoadingError, "Line $1: wrong address".format(idx + 1))

    # Process opcode.
    let opcode = line.parseOpcode(idx + 1, pos)
    vm.memory.add(byte(opcode))

    # Process operand.
    case opcode

    of opFetch, opStore:
      # Find memory index.
      let memIndex = line.parseMemoryIndex(idx + 1, pos)
      vm.memory.add(cast[BytesValue](Value(memIndex)))
      inc pc, 5

    of opJmp, opJz:
      # Find offset.
      let offset = line.parseOffset(idx + 1, pos)
      vm.memory.add(cast[BytesValue](Value(offset)))
      # Find and check branch address.
      let branchAddress = line.parseValue(idx + 1, pos, "branch address expected")
      if branchAddress != pc + offset + 1:
        raise newException(LoadingError, "Line $1: wrong branch address".format(idx + 1))
      inc pc, 5

    of opPush:
      # Find value.
      let value = line.parseValue(idx + 1, pos, "value expected")
      vm.memory.add(cast[BytesValue](Value(value)))
      inc pc, 5

    else:
      inc pc

#———————————————————————————————————————————————————————————————————————————————————————————————————

let code = if paramCount() == 0: stdin.readAll() else: paramStr(1).readFile()
var vm: VM

vm.load(code)
vm.run()
