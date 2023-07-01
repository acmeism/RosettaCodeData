//
// The Rosetta Code Virtual Machine in D.
//
// This code was migrated from an implementation in ATS. I have tried
// to keep it possible to compare the two languages easily, although
// in some cases the demonstration of "low level" techniques in ATS
// (such as avoiding memory leaks that might require garbage
// collection), or the use of linked lists as intermediate storage, or
// other such matters, seemed inappropriate to duplicate in D
// programming.
//
// (For example: in ATS, using a fully built linked list to initialize
// an array solves typechecking issues that simply do not exist in D's
// type system.)
//

import std.ascii;
import std.conv;
import std.stdint;
import std.stdio;
import std.string;
import std.typecons;

enum Op {
  HALT    = 0x0000,  // 00000
  ADD     = 0x0001,  // 00001
  SUB     = 0x0002,  // 00010
  MUL     = 0x0003,  // 00011
  DIV     = 0x0004,  // 00100
  MOD     = 0x0005,  // 00101
  LT      = 0x0006,  // 00110
  GT      = 0x0007,  // 00111
  LE      = 0x0008,  // 01000
  GE      = 0x0009,  // 01001
  EQ      = 0x000A,  // 01010
  NE      = 0x000B,  // 01011
  AND     = 0x000C,  // 01100
  OR      = 0x000D,  // 01101
  NEG     = 0x000E,  // 01110
  NOT     = 0x000F,  // 01111
  PRTC    = 0x0010,  // 10000
  PRTI    = 0x0011,  // 10001
  PRTS    = 0x0012,  // 10010
  FETCH   = 0x0013,  // 10011
  STORE   = 0x0014,  // 10100
  PUSH    = 0x0015,  // 10101
  JMP     = 0x0016,  // 10110
  JZ      = 0x0017   // 10111
}

const string[] opcodeOrder =
  ["halt",  // 00000   bit pattern
   "add",   // 00001
   "sub",   // 00010
   "mul",   // 00011
   "div",   // 00100
   "mod",   // 00101
   "lt",    // 00110
   "gt",    // 00111
   "le",    // 01000
   "ge",    // 01001
   "eq",    // 01010
   "ne",    // 01011
   "and",   // 01100
   "or",    // 01101
   "neg",   // 01110
   "not",   // 01111
   "prtc",  // 10000
   "prti",  // 10001
   "prts",  // 10010
   "fetch", // 10011
   "store", // 10100
   "push",  // 10101
   "jmp",   // 10110
   "jz"];   // 10111

enum Register {
  PC = 0,
  SP = 1,
  MAX = SP
}

alias vmint = uint32_t;

class VM {
  string[] strings;
  ubyte[] code;
  vmint[] data;
  vmint[] stack;
  vmint[Register.MAX + 1] registers;
}

class BadVMException : Exception
{
  this(string msg, string file = __FILE__, size_t line = __LINE__)
  {
    super(msg, file, line);
  }
}

class VMRuntimeException : Exception
{
  this(string msg, string file = __FILE__, size_t line = __LINE__)
  {
    super(msg, file, line);
  }
}

vmint
twosComplement (vmint x)
{
  // This computes the negative of x, if x is regarded as signed.
  pragma(inline);
  return (~x) + vmint(1U);
}

vmint
add (vmint x, vmint y)
{
  // This works whether x or y is regarded as unsigned or signed.
  pragma(inline);
  return x + y;
}

vmint
sub (vmint x, vmint y)
{
  // This works whether x or y is regarded as unsigned or signed.
  pragma(inline);
  return x - y;
}

vmint
equality (vmint x, vmint y)
{
  pragma(inline);
  return vmint(x == y);
}

vmint
inequality (vmint x, vmint y)
{
  pragma(inline);
  return vmint(x != y);
}

vmint
signedLt (vmint x, vmint y)
{
  pragma(inline);
  return vmint(int32_t(x) < int32_t(y));
}

vmint
signedGt (vmint x, vmint y)
{
  pragma(inline);
  return vmint(int32_t(x) > int32_t(y));
}

vmint
signedLte (vmint x, vmint y)
{
  pragma(inline);
  return vmint(int32_t(x) <= int32_t(y));
}

vmint
signedGte (vmint x, vmint y)
{
  pragma(inline);
  return vmint(int32_t(x) >= int32_t(y));
}

vmint
signedMul (vmint x, vmint y)
{
  pragma(inline);
  return vmint(int32_t(x) * int32_t(y));
}

vmint
signedDiv (vmint x, vmint y)
{
  pragma(inline);
  return vmint(int32_t(x) / int32_t(y));
}

vmint
signedMod (vmint x, vmint y)
{
  pragma(inline);
  return vmint(int32_t(x) % int32_t(y));
}

vmint
logicalNot (vmint x)
{
  pragma(inline);
  return vmint(!x);
}

vmint
logicalAnd (vmint x, vmint y)
{
  pragma(inline);
  return vmint((!!x) * (!!y));
}

vmint
logicalOr (vmint x, vmint y)
{
  pragma(inline);
  return (vmint(1) - vmint((!x) * (!y)));
}

vmint
parseDigits (string s, size_t i, size_t j)
{
  const badInteger = "bad integer";

  if (j == i)
    throw new BadVMException (badInteger);
  auto x = vmint(0);
  for (size_t k = i; k < j; k += 1)
    if (!isDigit (s[k]))
      throw new BadVMException (badInteger);
    else
      // The result is allowed to overflow freely.
      x = (vmint(10) * x) + vmint(s[k] - '0');
  return x;
}

vmint
parseInteger (string s, size_t i, size_t j)
{
  const badInteger = "bad integer";

  vmint retval;
  if (j == i)
    throw new BadVMException (badInteger);
  else if (j == i + vmint(1) && !isDigit (s[i]))
    throw new BadVMException (badInteger);
  else if (s[i] != '-')
    retval = parseDigits (s, i, j);
  else if (j == i + vmint(1))
    throw new BadVMException (badInteger);
  else
    retval = twosComplement (parseDigits (s, i + vmint(1), j));
  return retval;
}

size_t
skipWhitespace (string s, size_t n, size_t i)
{
  while (i < n && isWhite (s[i]))
    i += 1;
  return i;
}

size_t
skipNonwhitespace (string s, size_t n, size_t i)
{
  while (i < n && !isWhite (s[i]))
    i += 1;
  return i;
}

bool
substrEqual (string s, size_t i, size_t j, string t)
{
  // Is s[i .. j-1] equal to t?

  auto retval = false;
  auto m = t.length;
  if (m == j - i)
    {
      auto k = size_t(0);
      while (k < m && s[i + k] == t[k])
        k += 1;
      retval = (k == m);
    }
  return retval;
}

string
dequoteString (string s, size_t n)
{
  const badQuotedString = "bad quoted string";

  string t = "";
  s = strip(s);
  if (s.length < 2 || s[0] != '"' || s[$ - 1] != '"')
    throw new BadVMException (badQuotedString);
  auto i = 1;
  while (i < s.length - 1)
    if (s[i] != '\\')
      {
        t ~= s[i];
        i += 1;
      }
    else if (i + 1 == s.length - 1)
      throw new BadVMException (badQuotedString);
    else if (s[i + 1] == 'n')
      {
        t ~= '\n';
        i += 2;
      }
    else if (s[i + 1] == '\\')
      {
        t ~= '\\';
        i += 2;
      }
    else
      throw new BadVMException (badQuotedString);
  return t;
}

string[]
readStrings (File f, size_t stringsSize)
{
  const badQuotedString = "Bad quoted string.";

  string[] strings;
  strings.length = stringsSize;
  for (size_t k = 0; k < stringsSize; k += 1)
    {
      auto line = f.readln();
      strings[k] = dequoteString (line, line.length);
    }
  return strings;
}

ubyte
opcodeNameTo_ubyte (string str, size_t i, size_t j)
{
  size_t k = 0;
  while (k < opcodeOrder.length &&
         !substrEqual (str, i, j, opcodeOrder[k]))
    k += 1;
  if (k == opcodeOrder.length)
    throw new BadVMException ("unrecognized opcode name");
  return to!ubyte(k);
}

ubyte
vmintByte0 (vmint i)
{
  return (i & 0xFF);
}

ubyte
vmintByte1 (vmint i)
{
  return ((i >> 8) & 0xFF);
}

ubyte
vmintByte2 (vmint i)
{
  return ((i >> 16) & 0xFF);
}

ubyte
vmintByte3 (vmint i)
{
  return (i >> 24);
}

ubyte[]
parseInstruction (string line)
{
  const bad_instruction = "bad VM instruction";

  const n = line.length;
  auto i = skipWhitespace (line, n, 0);

  // Skip the address field.
  i = skipNonwhitespace (line, n, i);

  i = skipWhitespace (line, n, i);
  auto j = skipNonwhitespace (line, n, i);
  auto opcode = opcodeNameTo_ubyte (line, i, j);

  auto startOfArgument = j;

  ubyte[] finishPush ()
  {
    const i1 = skipWhitespace (line, n, startOfArgument);
    const j1 = skipNonwhitespace (line, n, i1);
    const arg = parseInteger (line, i1, j1);
    // Little-endian storage.
    return [opcode, vmintByte0 (arg), vmintByte1 (arg),
            vmintByte2 (arg), vmintByte3 (arg)];
  }

  ubyte[] finishFetchOrStore ()
  {
    const i1 = skipWhitespace (line, n, startOfArgument);
    const j1 = skipNonwhitespace (line, n, i1);
    if (j1 - i1 < 3 || line[i1] != '[' || line[j1 - 1] != ']')
      throw new BadVMException (bad_instruction);
    const arg = parseInteger (line, i1 + 1, j1 - 1);
    // Little-endian storage.
    return [opcode, vmintByte0 (arg), vmintByte1 (arg),
            vmintByte2 (arg), vmintByte3 (arg)];
  }

  ubyte[] finishJmpOrJz ()
  {
    const i1 = skipWhitespace (line, n, startOfArgument);
    const j1 = skipNonwhitespace (line, n, i1);
    if (j1 - i1 < 3 || line[i1] != '(' || line[j1 - 1] != ')')
      throw new BadVMException (bad_instruction);
    const arg = parseInteger (line, i1 + 1, j1 - 1);
    // Little-endian storage.
    return [opcode, vmintByte0 (arg), vmintByte1 (arg),
            vmintByte2 (arg), vmintByte3 (arg)];
  }

  ubyte[] retval;
  switch (opcode)
    {
    case Op.PUSH:
      retval = finishPush ();
      break;
    case Op.FETCH:
    case Op.STORE:
      retval = finishFetchOrStore ();
      break;
    case Op.JMP:
    case Op.JZ:
      retval = finishJmpOrJz ();
      break;
    default:
      retval = [opcode];
      break;
    }

  return retval;
}

ubyte[]
readCode (File f)
{
  // Read the instructions from the input, producing an array of
  // array of instruction bytes.
  ubyte[] code = [];
  auto line = f.readln();
  while (line !is null)
    {
      code ~= parseInstruction (line);
      line = f.readln();
    }
  return code;
}

void
parseHeaderLine (string line, ref size_t dataSize,
                 ref size_t stringsSize)
{
  const bad_vm_header_line = "bad VM header line";

  const n = line.length;
  auto i = skipWhitespace (line, n, 0);
  auto j = skipNonwhitespace (line, n, i);
  if (!substrEqual (line, i, j, "Datasize:"))
    throw new BadVMException (bad_vm_header_line);
  i = skipWhitespace (line, n, j);
  j = skipNonwhitespace (line, n, i);
  dataSize = parseInteger (line, i, j);
  i = skipWhitespace (line, n, j);
  j = skipNonwhitespace (line, n, i);
  if (!substrEqual (line, i, j, "Strings:"))
    throw new BadVMException (bad_vm_header_line);
  i = skipWhitespace (line, n, j);
  j = skipNonwhitespace (line, n, i);
  stringsSize = parseInteger (line, i, j);
}

VM
readVM (File f)
{
  const line = f.readln();

  size_t dataSize;
  size_t stringsSize;
  parseHeaderLine (line, dataSize, stringsSize);

  VM vm = new VM();
  vm.strings = readStrings (f, stringsSize);
  vm.code = readCode (f);
  vm.data.length = dataSize;
  vm.stack.length = 65536; // A VERY big stack, MUCH bigger than is
                           // "reasonable" for this VM. The same size
                           // as in the ATS, however.
  vm.registers[Register.PC] = vmint(0);
  vm.registers[Register.SP] = vmint(0);

  return vm;
}

vmint
pop (VM vm)
{
  pragma(inline);
  const spBefore = vm.registers[Register.SP];
  if (spBefore == 0)
    throw new VMRuntimeException ("stack underflow");
  const spAfter = spBefore - vmint(1);
  vm.registers[Register.SP] = spAfter;
  return vm.stack[spAfter];
}

void
push (VM vm, vmint x)
{
  pragma(inline);
  const spBefore = vm.registers[Register.SP];
  if (vm.stack.length <= spBefore)
    throw new VMRuntimeException ("stack overflow");
  vm.stack[spBefore] = x;
  const spAfter = spBefore + vmint(1);
  vm.registers[Register.SP] = spAfter;
}

vmint
fetchData (VM vm, vmint index)
{
  pragma(inline);
  if (vm.data.length <= index)
    throw new VMRuntimeException
      ("fetch from outside the data section");
  return vm.data[index];
}

void
storeData (VM vm, vmint index, vmint x)
{
  pragma(inline);
  if (vm.data.length <= index)
    throw new VMRuntimeException
      ("store to outside the data section");
  vm.data[index] = x;
}

vmint
getArgument (VM vm)
{
  pragma(inline);
  auto pc = vm.registers[Register.PC];
  if (vm.code.length <= pc + vmint(4))
    throw new VMRuntimeException
      ("the program counter is out of bounds");
  // The data is stored little-endian.
  const byte0 = vmint (vm.code[pc]);
  const byte1 = vmint (vm.code[pc + vmint(1)]);
  const byte2 = vmint (vm.code[pc + vmint(2)]);
  const byte3 = vmint (vm.code[pc + vmint(3)]);
  return (byte0) | (byte1 << 8) | (byte2 << 16) | (byte3 << 24);
}

void
skipArgument (VM vm)
{
  pragma(inline);
  vm.registers[Register.PC] += vmint(4);
}

//
// The string mixins below are going to do for us *some* of what the
// ATS template system did for us. The two methods hardly resemble
// each other, but both can be used to construct function definitions
// at compile time.
//

template
UnaryOperation (alias name, alias func)
{
  const char[] UnaryOperation =
    "void " ~
    name ~ " (VM vm)
    {
      pragma(inline);
      const sp = vm.registers[Register.SP];
      if (sp == vmint(0))
        throw new VMRuntimeException (\"stack underflow\");
      const x = vm.stack[sp - vmint(1)];
      const z = " ~ func ~ " (x);
      vm.stack[sp - vmint(1)] = z;
    }";
}

template
BinaryOperation (alias name, alias func)
{
  const char[] BinaryOperation =
    "void " ~
    name ~ " (VM vm)
    {
      pragma(inline);
      const spBefore = vm.registers[Register.SP];
      if (spBefore <= vmint(1))
        throw new VMRuntimeException (\"stack underflow\");
      const spAfter = spBefore - vmint(1);
      vm.registers[Register.SP] = spAfter;
      const x = vm.stack[spAfter - vmint(1)];
      const y = vm.stack[spAfter];
      const z = " ~ func ~ "(x, y);
      vm.stack[spAfter - vmint(1)] = z;
    }";
}

mixin (UnaryOperation!("uopNeg", "twosComplement"));
mixin (UnaryOperation!("uopNot", "logicalNot"));

mixin (BinaryOperation!("binopAdd", "add"));
mixin (BinaryOperation!("binopSub", "sub"));
mixin (BinaryOperation!("binopMul", "signedMul"));
mixin (BinaryOperation!("binopDiv", "signedDiv"));
mixin (BinaryOperation!("binopMod", "signedMod"));
mixin (BinaryOperation!("binopEq", "equality"));
mixin (BinaryOperation!("binopNe", "inequality"));
mixin (BinaryOperation!("binopLt", "signedLt"));
mixin (BinaryOperation!("binopGt", "signedGt"));
mixin (BinaryOperation!("binopLe", "signedLte"));
mixin (BinaryOperation!("binopGe", "signedGte"));
mixin (BinaryOperation!("binopAnd", "logicalAnd"));
mixin (BinaryOperation!("binopOr", "logicalOr"));

void
doPush (VM vm)
{
  pragma(inline);
  const arg = getArgument (vm);
  push (vm, arg);
  skipArgument (vm);
}

void
doFetch (VM vm)
{
  pragma(inline);
  const i = getArgument (vm);
  const x = fetchData (vm, i);
  push (vm, x);
  skipArgument (vm);
}

void
doStore (VM vm)
{
  pragma(inline);
  const i = getArgument (vm);
  const x = pop (vm);
  storeData (vm, i, x);
  skipArgument (vm);
}

void
doJmp (VM vm)
{
  pragma(inline);
  const arg = getArgument (vm);
  vm.registers[Register.PC] += arg;
}

void
doJz (VM vm)
{
  pragma(inline);
  const x = pop (vm);
  if (x == vmint(0))
    doJmp (vm);
  else
    skipArgument (vm);
}

void
doPrtc (File fOut, VM vm)
{
  const x = pop (vm);
  fOut.write (to!char(x));
}

void
doPrti (File fOut, VM vm)
{
  const x = pop (vm);
  fOut.write (int32_t(x));
}

void
doPrts (File fOut, VM vm)
{
  const i = pop (vm);
  if (vm.strings.length <= i)
    throw new VMRuntimeException ("string index out of bounds");
  fOut.write (vm.strings[i]);
}

void
vmStep (File fOut, VM vm, ref bool machineHalt, ref bool badOpcode)
{
  const pc = vm.registers[Register.PC];
  if (vm.code.length <= pc)
    throw new VMRuntimeException
      ("the program counter is out of bounds");
  vm.registers[Register.PC] = pc + vmint(1);
  const opcode = vm.code[pc];
  const uOpcode = uint(opcode);

  // Dispatch by bifurcation on the bit pattern of the opcode. This
  // method is logarithmic in the number of opcode values.

  machineHalt = false;
  badOpcode = false;
  if ((uOpcode & (~0x1FU)) == 0U)
    {
      if ((uOpcode & 0x10U) == 0U)
        {
          if ((uOpcode & 0x08U) == 0U)
            {
              if ((uOpcode & 0x04U) == 0U)
                {
                  if ((uOpcode & 0x02U) == 0U)
                    {
                      if ((uOpcode & 0x01U) == 0U)
                        machineHalt = true;
                      else
                        binopAdd (vm);
                    }
                  else
                    {
                      if ((uOpcode & 0x01U) == 0U)
                        binopSub (vm);
                      else
                        binopMul (vm);
                    }
                }
              else
                {
                  if ((uOpcode & 0x02U) == 0U)
                    {
                      if ((uOpcode & 0x01U) == 0U)
                        binopDiv (vm);
                      else
                        binopMod (vm);
                    }
                  else
                    {
                      if ((uOpcode & 0x01U) == 0U)
                        binopLt (vm);
                      else
                        binopGt (vm);
                    }
                }
            }
          else
            {
              if ((uOpcode & 0x04U) == 0U)
                {
                  if ((uOpcode & 0x02U) == 0U)
                    {
                      if ((uOpcode & 0x01U) == 0U)
                        binopLe (vm);
                      else
                        binopGe (vm);
                    }
                  else
                    {
                      if ((uOpcode & 0x01U) == 0U)
                        binopEq (vm);
                      else
                        binopNe (vm);
                    }
                }
              else
                {
                  if ((uOpcode & 0x02U) == 0U)
                    {
                      if ((uOpcode & 0x01U) == 0U)
                        binopAnd (vm);
                      else
                        binopOr (vm);
                    }
                  else
                    {
                      if ((uOpcode & 0x01U) == 0U)
                        uopNeg (vm);
                      else
                        uopNot (vm);
                    }
                }
            }
        }
      else
        {
          if ((uOpcode & 0x08U) == 0U)
            {
              if ((uOpcode & 0x04U) == 0U)
                {
                  if ((uOpcode & 0x02U) == 0U)
                    {
                      if ((uOpcode & 0x01U) == 0U)
                        doPrtc (fOut, vm);
                      else
                        doPrti (fOut, vm);
                    }
                  else
                    {
                      if ((uOpcode & 0x01U) == 0U)
                        doPrts (fOut, vm);
                      else
                        doFetch (vm);
                    }
                }
              else
                {
                  if ((uOpcode & 0x02U) == 0U)
                    {
                      if ((uOpcode & 0x01U) == 0U)
                        doStore (vm);
                      else
                        doPush (vm);
                    }
                  else
                    {
                      if ((uOpcode & 0x01U) == 0U)
                        doJmp (vm);
                      else
                        doJz (vm);
                    }
                }
            }
          else
            badOpcode = true;
        }
    }
  else
    badOpcode = true;
}

void
vmContinue (File fOut, VM vm)
{
  auto machineHalt = false;
  auto badOpcode = false;
  while (!machineHalt && !badOpcode)
    vmStep (fOut, vm, machineHalt, badOpcode);
  if (badOpcode)
    throw new VMRuntimeException ("unrecognized opcode at runtime");
}

void
vmInitialize (VM vm)
{
  foreach (ref x; vm.data)
    x = vmint(0);
  vm.registers[Register.PC] = vmint(0);
  vm.registers[Register.SP] = vmint(0);
}

void
vmRun (File fOut, VM vm)
{
  vmInitialize (vm);
  vmContinue (fOut, vm);
}

void
ensure_that_vmint_is_suitable ()
{
  // Try to guarantee that vmint is exactly 32 bits, and that it
  // allows overflow in either direction.
  assert (vmint(0xFFFFFFFFU) + vmint(1U) == vmint(0U));
  assert (vmint(0U) - vmint(1U) == vmint(0xFFFFFFFFU));
  assert (vmint(-1234) == twosComplement (vmint(1234)));
}

int
main (char[][] args)
{
  auto inpFilename = "-";
  auto outFilename = "-";
  if (2 <= args.length)
    inpFilename = to!string (args[1]);
  if (3 <= args.length)
    outFilename = to!string (args[2]);

  auto inpF = stdin;
  if (inpFilename != "-")
    inpF = File (inpFilename, "r");
  auto vm = readVM (inpF);
  if (inpFilename != "-")
    inpF.close();

  auto outF = stdout;
  if (outFilename != "-")
    outF = File (outFilename, "w");
  ensure_that_vmint_is_suitable ();
  vmRun (outF, vm);
  if (outFilename != "-")
    outF.close();

  return 0;
}
