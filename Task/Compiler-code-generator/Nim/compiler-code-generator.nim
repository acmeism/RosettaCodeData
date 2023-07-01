import os, re, streams, strformat, strutils, tables, std/decls

type

  # AST node types.
  NodeKind = enum
             nIdentifier = "Identifier"
             nString = "String"
             nInteger = "Integer"
             nSequence = "Sequence"
             nIf = "If"
             nPrtc = "Prtc"
             nPrts = "Prts"
             nPrti = "Prti"
             nWhile = "While"
             nAssign = "Assign"
             nNegate = "Negate"
             nNot = "Not"
             nMultiply = "Multiply"
             nDivide = "Divide"
             nMod = "Mod"
             nAdd = "Add"
             nSubtract = "Subtract"
             nLess = "Less"
             nLessEqual = "LessEqual"
             nGreater = "Greater"
             nGreaterEqual = "GreaterEqual"
             nEqual = "Equal"
             nNotEqual = "NotEqual"
             nAnd = "And"
             nOr = "Or"

  # Ast node description.
  Node = ref object
    left: Node
    right: Node
    case kind: NodeKind
    of nString: stringVal: string
    of nInteger: intVal: int
    of nIdentifier: name: string
    else: nil

  # Virtual machine opcodes.
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

  # Code generator context.
  CodeGen = object
    address: int              # Current address in code part.
    instr: seq[string]        # List of instructions.
    vars: Table[string, int]  # Mapping variable name -> variable index.
    strings: seq[string]      # List of strings.

  # Node ranges.
  UnaryOpNode = range[nNegate..nNot]
  BinaryOpNode = range[nMultiply..nOr]
  PrintNode = range[nPrtc..nPrti]


const

  # Mapping unary operator Node -> OpCode.
  UnOp: array[UnaryOpNode, OpCode] = [opNeg, opNot]

  # Mapping binary operator Node -> OpCode.
  BinOp: array[BinaryOpNode, OpCode] = [opMul, opDiv, opMod, opAdd, opSub, opLt,
                                        opLe, opGt, opGe, opEq, opNe, opAnd, opOr]

  # Mapping print Node -> OpCode.
  PrintOp: array[PrintNode, OpCode] = [opPrtc, opPrts, opPrti]


####################################################################################################
# Code generator.

proc genSimpleInst(gen: var CodeGen; opcode: OpCode) =
  ## Build a simple instruction (no operand).
  gen.instr.add &"{gen.address:>5} {opcode}"

#---------------------------------------------------------------------------------------------------

proc genMemInst(gen: var CodeGen; opcode: OpCode; memIndex: int) =
  ## Build a memory access instruction (opFetch, opStore).
  gen.instr.add &"{gen.address:>5} {opcode:<5} [{memIndex}]"

#---------------------------------------------------------------------------------------------------

proc genJumpInst(gen: var CodeGen; opcode: OpCode): int =
  ## Build a jump instruction. We use the letters X and Y as placeholders
  ## for the offset and the target address.
  result = gen.instr.len
  gen.instr.add &"{gen.address:>5} {opcode:<5} (X) Y"

#---------------------------------------------------------------------------------------------------

proc genPush(gen: var CodeGen; value: int) =
  ## Build a push instruction.
  gen.instr.add &"{gen.address:>5} {opPush:<5} {value}"

#---------------------------------------------------------------------------------------------------

proc updateJumpInst(gen: var CodeGen; index: int; jumpAddress, targetAddress: int) =
  ## Update the offset and the target address of a jump instruction.

  var instr {.byAddr.} = gen.instr[index]
  let offset = targetAddress - jumpAddress - 1
  for idx in countdown(instr.high, 0):
    case instr[idx]
    of 'Y':
      instr[idx..idx] = $targetAddress
    of 'X':
      instr[idx..idx] = $offset
      break
    else:
      discard

#---------------------------------------------------------------------------------------------------

proc process(gen: var CodeGen; node: Node) =
  ## Generate code for a node.

  if node.isNil: return

  case node.kind:

  of nInteger:
    gen.genPush(node.intVal)
    inc gen.address, 5

  of nIdentifier:
    if node.name notin gen.vars:
      gen.vars[node.name] = gen.vars.len
    gen.genMemInst(opFetch, gen.vars[node.name])
    inc gen.address, 5

  of nString:
    var index = gen.strings.find(node.stringVal)
    if index < 0:
      index = gen.strings.len
      gen.strings.add(node.stringVal)
    gen.genPush(index)
    inc gen.address, 5

  of nAssign:
    gen.process(node.right)
    if node.left.name notin gen.vars:
      gen.vars[node.left.name] = gen.vars.len
    gen.genMemInst(opStore, gen.vars[node.left.name])
    inc gen.address, 5

  of UnaryOpNode.low..UnaryOpNode.high:
    gen.process(node.left)
    gen.genSimpleInst(UnOp[node.kind])
    inc gen.address

  of BinaryOpNode.low..BinaryOpNode.high:
    gen.process(node.left)
    gen.process(node.right)
    gen.genSimpleInst(BinOp[node.kind])
    inc gen.address

  of PrintNode.low..PrintNode.high:
    gen.process(node.left)
    gen.genSimpleInst(PrintOp[node.kind])
    inc gen.address

  of nIf:
    # Generate condition expression.
    gen.process(node.left)
    # Generate jump if zero.
    let jzAddr = gen.address
    let jzInst = gen.genJumpInst(opJz)
    inc gen.address, 5
    # Generate then branch expression.
    gen.process(node.right.left)
    # If there is an "else" clause, generate unconditional jump
    var jmpAddr, jmpInst: int
    let hasElseClause = not node.right.right.isNil
    if hasElseClause:
      jmpAddr = gen.address
      jmpInst = gen.genJumpInst(opJmp)
      inc gen.address, 5
    # Update JZ offset.
    gen.updateJumpInst(jzInst, jzAddr, gen.address)
    # Generate else expression.
    if hasElseClause:
      gen.process(node.right.right)
      # Update JMP offset.
      gen.updateJumpInst(jmpInst, jmpAddr, gen.address)

  of nWhile:
    let condAddr = gen.address
    # Generate condition expression.
    gen.process(node.left)
    # Generate jump if zero.
    let jzAddr = gen.address
    let jzInst = gen.genJumpInst(opJz)
    inc gen.address, 5
    # Generate loop code.
    gen.process(node.right)
    # Generate unconditional jump.
    let jmpAddr = gen.address
    let jmpInst = gen.genJumpInst(opJmp)
    inc gen.address, 5
    # Update JMP offset.
    gen.updateJumpInst(jmpInst, jmpAddr, condAddr)
    # Update JZ offset.
    gen.updateJumpInst(jzInst, jzAddr, gen.address)

  of nSequence:
    gen.process(node.left)
    gen.process(node.right)

#---------------------------------------------------------------------------------------------------

proc run(gen: var CodeGen; ast: Node) =
  ## Run the code generator on the AST.

  # Process recursively the nodes.
  gen.process(ast)
  gen.genSimpleInst(opHalt)   # Add a Halt operator at the end.

  # Output header.
  echo &"Datasize: {gen.vars.len} Strings: {gen.strings.len}"
  # Output strings.
  for s in gen.strings:
    echo s.escape().replace("\\x0A", "\\n")
  # Output code.
  for inst in gen.instr:
    echo inst

####################################################################################################
# AST loader.

proc newNode(kind: NodeKind; left: Node; right: Node = nil): Node =
  ## Create a new node with given left and right children.
  result = Node(kind: kind, left: left, right: right)

#---------------------------------------------------------------------------------------------------

proc loadAst(stream: Stream): Node =
  ## Load a linear AST and build a binary tree.

  let line = stream.readLine().strip()
  if line.startsWith(';'):
    return nil

  var fields = line.split(' ', 1)
  let kind = parseEnum[NodeKind](fields[0])
  if kind in {nIdentifier, nString, nInteger}:
    if fields.len < 2:
      raise newException(ValueError, "Missing value field for " & fields[0])
    else:
      fields[1] = fields[1].strip()
  case kind
  of nIdentifier:
    return Node(kind: nIdentifier, name: fields[1])
  of nString:
    let str = fields[1].replacef(re"([^\\])(\\n)", "$1\n").replace(r"\\", r"\").replace("\"", "")
    return Node(kind: nString, stringVal: str)
  of nInteger:
    return Node(kind: nInteger, intVal: parseInt(fields[1]))
  else:
    if fields.len > 1:
      raise newException(ValueError, "Extra field for " & fields[0])

  let left = stream.loadAst()
  let right = stream.loadAst()
  result = newNode(kind, left, right)


#———————————————————————————————————————————————————————————————————————————————————————————————————

var stream: Stream
var toClose = false
var codegen: CodeGen

if paramCount() < 1:
  stream = newFileStream(stdin)
else:
  stream = newFileStream(paramStr(1))
  toClose = true

let ast = loadAst(stream)
if toClose: stream.close()

codegen.run(ast)
