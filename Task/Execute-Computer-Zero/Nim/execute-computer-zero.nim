import std/strformat

type
  OpCode = enum opNOP, opLDA, opSTA, opADD, opSUB, opBRZ, opJMP, opSTP
  Instruction = byte
  Address = 0..31
  # Definition of a computer zero.
  Computer = object
    mem: array[Address, byte]   # Memory.
    pc: Address                 # Program counter.
    acc: byte                   # Accumulator.
  Program = tuple
    name: string              # Name of the program.
    code: seq[Instruction]    # List of instructions.

proc split(inst: Instruction): tuple[code: OpCode, address: Address] =
  ## Split an instruction into an opCode and a value.
  (OpCode((inst and 0b11100000u8) shr 5), Address(inst and 0b00011111u8))

proc toInst(opCode: OpCode; address: int): Instruction =
  ## Build an instruction with given opcode and value.
  if address notin Address.low..Address.high:
    raise newException(ValueError, "address out of range.")
  byte(opCode) shl 5 or byte(address)

# Functions to build instructions.
func NOP(n: int): Instruction = toInst(opNOP, n)
func LDA(n: int): Instruction = toInst(opLDA, n)
func STA(n: int): Instruction = toInst(opSTA, n)
func ADD(n: int): Instruction = toInst(opADD, n)
func SUB(n: int): Instruction = toInst(opSUB, n)
func BRZ(n: int): Instruction = toInst(opBRZ, n)
func JMP(n: int): Instruction = toInst(opJMP, n)
func STP(n: int): Instruction = toInst(opSTP, n)

proc reset(comp: var Computer) =
  ## Reset the computer state.
  comp.mem.reset()
  comp.pc = 0
  comp.acc = 0

proc load(comp: var Computer; program: Program) =
  ## Load a program into a computer.
  comp.reset()
  var idx = 0
  for inst in program.code:
    comp.mem[idx] = inst
    inc idx

proc run(comp: var Computer) =
  ## Run a computer.
  ## The execution starts or resumes at the instruction
  ## at current PC, with current value in the accumulator.
  while true:
    let (opCode, address) = comp.mem[comp.pc].split()
    inc comp.pc
    case opCode
    of opNOP:
      discard
    of opLDA:
      comp.acc = comp.mem[address]
    of opSTA:
      comp.mem[address] = comp.acc
    of opADD:
      comp.acc += comp.mem[address]
    of opSUB:
      comp.acc -= comp.mem[address]
    of opBRZ:
      if comp.acc == 0:
        comp.pc = address
    of opJMP:
      comp.pc = address
    of opSTP:
      break

proc enterValue(comp: var Computer; value: byte) =
  ## Enter a value into memory at address given by the PC,
  ## then increment the PC.
  comp.mem[comp.pc] = value
  inc comp.pc


# Programs are built using the functions NOP, LDA, STA, etc.
# To be able to use Uniform Function Call Syntax (i.e. call without parentheses),
# all these functions have an argument, even NOP and STP.
const
  Prog1 = (name: "2+2",
           code: @[LDA  3, ADD  4, STP  0,      2,      2])
  Prog2 = (name: "7*8",
           code: @[LDA 12, ADD 10, STA 12, LDA 11, SUB 13, STA 11, BRZ  8, JMP  0,
                   LDA 12, STP  0,      8,      7,      0,      1])
  Prog3 = (name: "Fibonacci",
           code: @[LDA 14, STA 15, ADD 13, STA 14, LDA 15, STA 13, LDA 16, SUB 17,
                   BRZ 11, STA 16, JMP  0, LDA 14, STP  0,      1,      1,      0,
                        8,      1])
  Prog4 = (name: "List",
           code: @[LDA 13, ADD 15, STA  5, ADD 16, STA  7, NOP  0, STA 14, NOP  0,
                   BRZ 11, STA 15, JMP  0, LDA 14, STP  0, LDA  0,      0,     28,
                        1,      0,      0,      0,      6,      0,      2,     26,
                        5,     20,      3,     30,      1,     22,      4,     24])
  Prog5 = (name: "Prisoner",
           code: @[NOP  0, NOP  0, STP  0, NOP  0, LDA  3, SUB 29, BRZ 18, LDA  3,
                   STA 29, BRZ 14, LDA  1, ADD 31, STA  1, JMP  2, LDA  0, ADD 31,
                   STA  0, JMP  2, LDA  3, STA 29, LDA  1, ADD 30, ADD  3, STA  1,
                   LDA  0, ADD 30, ADD  3, STA  0, JMP  2,      0,      1,      3])

var computer: Computer

for prog in [Prog1, Prog2, Prog3, Prog4]:
  computer.load prog
  computer.run()
  echo &"Result for {prog.name}: {computer.acc}"

# "Prog5" is different as it stops and waits for an input from the user.
# Input is stored at address 3 (current PC value) and scores are stored at addresses 0 and 1.

type Action = enum cooperate, defect

echo &"\nResult for {Prog5.name}:"
computer.load Prog5
computer.run()

for round in 1..5:
  let action = Action(round and 1)
  computer.enterValue(byte(action))
  computer.run()
  echo &"Round {round}  Action: {action:9}  Player: {computer.mem[0]}  Computer: {computer.mem[1]}"
