import macros
import strutils
import tables

const Diagram = """
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
         |                      ID                       |
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
         |QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
         |                    QDCOUNT                    |
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
         |                    ANCOUNT                    |
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
         |                    NSCOUNT                    |
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
         |                    ARCOUNT                    |
         +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+"""

####################################################################################################
# Exceptions.

type

  # Exceptions.
  SyntaxError = object of CatchableError
  StructureError = object of CatchableError
  FieldError = object of CatchableError

#---------------------------------------------------------------------------------------------------

proc raiseException(exc: typedesc; linenum: int; message: string) =
  ## Raise an exception with a message including the line number.
  raise newException(exc, "Line $1: $2".format(linenum, message))


####################################################################################################
# Parser.

type

  # Allowed tokens.
  Token = enum tkSpace, tkPlus, tkMinus2, tkVLine, tkIdent, tkEnd, tkError

  # Lexer description.
  Lexer = object
    line: string      # Line to parse.
    linenum: int      # Line number.
    pos: int          # Current position.
    token: Token      # Current token.
    value: string     # Associated value (for tkIdent).

  # Description of a field.
  Field = tuple[name: string, length: int]

  # Description of fields in a row.
  RowFields = seq[Field]

  # Structure to describe fields.
  RawStructure = object
    size: int                # Size of a row in bits.
    rows: seq[RowFields]     # List of rows.

#---------------------------------------------------------------------------------------------------

proc getNextToken(lexer: var Lexer) =
  ## Search next toke/* {{header|Nim}} */ n and update lexer state accordingly.

  doAssert(lexer.pos < lexer.line.high)

  inc lexer.pos
  let ch = lexer.line[lexer.pos]
  case ch

  of ' ':
    lexer.token = tkSpace

  of '+':
    lexer.token = tkPlus

  of '-':
    inc lexer.pos
    lexer.token = if lexer.line[lexer.pos] == '-': tkMinus2 else: tkError

  of '|':
    lexer.token = tkVLine

  of Letters:
    # Beginning of an identifier.
    lexer.value = $ch
    inc lexer.pos
    while lexer.pos < lexer.line.high and lexer.line[lexer.pos] in IdentChars:
      lexer.value.add(lexer.line[lexer.pos])
      inc lexer.pos
    dec lexer.pos
    lexer.token = tkIdent

  of '\n':
    # End of the line.
    lexer.token = tkEnd

  else:
    lexer.token = tkError

#---------------------------------------------------------------------------------------------------

proc initLexer(line: string; linenum: int): Lexer =
  ## Initialize a lexer.

  result.line = line & '\n'   # Add a sentinel.
  result.linenum = linenum
  result.pos = -1

#---------------------------------------------------------------------------------------------------

proc parseSepLine(lexer: var Lexer): int =
  ## Parse a separation line. Return the corresponding size in bits.

  lexer.getNextToken()
  while lexer.token != tkEnd:
    if lexer.token != tkMinus2:
      raiseException(SyntaxError, lexer.linenum, "“--” expected")
    lexer.getNextToken()
    if lexer.token != tkPlus:
      raiseException(SyntaxError, lexer.linenum, "“+” expected")
    inc result
    lexer.getNextToken()

#---------------------------------------------------------------------------------------------------

proc parseFieldLine(lexer: var Lexer; structure: var RawStructure) =
  ## Parse a field description line and update the structure accordingly.

  var rowFields: RowFields    # List of fields.
  var prevpos = 0             # Previous position.
  var size = 0                # Total size.

  lexer.getNextToken()
  while lexer.token != tkEnd:

    # Parse a field.
    while lexer.token == tkSpace:
      lexer.getNextToken()
    if lexer.token != tkIdent:
      raiseException(SyntaxError, lexer.linenum, "Identifier expected")
    let id = lexer.value
    lexer.getNextToken()
    while lexer.token == tkSpace:
      lexer.getNextToken()
    if lexer.token != tkVLine:
      raiseException(SyntaxError, lexer.linenum, "“|” expected")
    if lexer.pos mod 3 != 0:
      raiseException(SyntaxError, lexer.linenum, "wrong position for “|”")

    # Build a field description.
    let fieldLength = (lexer.pos - prevpos) div 3
    rowFields.add((id, fieldLength))
    inc size, fieldLength
    prevpos = lexer.pos
    lexer.getNextToken()

  # Add the row fields description to the structure.
  if size != structure.size:
    raiseException(StructureError, lexer.linenum, "total size of fields doesn’t fit")
  structure.rows.add(rowFields)

#---------------------------------------------------------------------------------------------------

proc parseLine(line: string; linenum: Positive; structure: var RawStructure) =
  ## Parse a line.

  # Eliminate spaces at beginning and at end, and ignore empty lines.
  let line = line.strip()
  if line.len == 0: return

  var lexer = initLexer(line, linenum)
  lexer.getNextToken()

  if lexer.token == tkPlus:
    # Separator line.
    let size = parseSepLine(lexer)
    if size notin {8, 16, 32, 64}:
      raiseException(StructureError, linenum,
                     "wrong structure size; got $1, expected 8, 16, 32 or 64".format(size))
    if structure.size > 0:
      # Not the first separation line.
      if size != structure.size:
        raiseException(StructureError, linenum,
                       "inconsistent size; got $1, expected $2".format(size, structure.size))
    else:
      structure.size = size

  elif lexer.token == tkVLine:
    # Fields description line.
    parseFieldLine(lexer, structure)

  else:
    raiseException(SyntaxError, linenum, "“+” or “|” expected")

#---------------------------------------------------------------------------------------------------

proc parse(diagram: string): RawStructure =
  ## Parse a diagram describing a structure.

  var linenum = 0
  for line in diagram.splitLines():
    inc linenum
    parseLine(line, linenum, result)


####################################################################################################
# Generation of a structure type at compile time.
# Access to fields is done directly without getter or setter.

macro createStructType*(diagram, typeName: static string): untyped =
  ## Create a type from "diagram" whose name is given by "typeName".

  # C types to use as units.
  const Ctypes = {8: "cuchar", 16: "cushort", 32: "cuint", 64: "culong"}.toTable

  # Check that the type name is a valid identifier.
  if not typeName.validIdentifier():
    error("Invalid type name: " & typeName)
    return

  # Parse the diagram.
  var struct: RawStructure
  try:
    struct = parse(diagram)
  except SyntaxError, StructureError:
    error(getCurrentExceptionMsg())
    return

  # Build the beginning: "type <typeName> = object".
  # For now, the list of fields is empty.
  let ctype = Ctypes[struct.size]
  let recList = newNimNode(nnkRecList)
  result = nnkStmtList.newTree(
             nnkTypeSection.newTree(
               nnkTypeDef.newTree(
                 ident(typeName),
                 newEmptyNode(),
                 nnkObjectTy.newTree(
                   newEmptyNode(),
                   newEmptyNode(),
                   recList))))

  # Add the fields.
  for row in struct.rows:
    if row.len == 1:
      # Single field in a unit. No need to specify the length.
      recList.add(newIdentDefs(
                    nnkPostfix.newTree(
                      ident("*"),
                      ident(row[0].name)),
                    ident(ctype)))
    else:
      # Several fields. Use pragma "bitsize".
      for field in row:
        let fieldNode = nnkPragmaExpr.newTree(
                          nnkPostfix.newTree(
                            ident("*"),
                            ident(field.name)),
                          nnkPragma.newTree(
                            nnkExprColonExpr.newTree(
                              ident("bitsize"),
                              newIntLitNode(field.length))))
        recList.add(newIdentDefs(fieldNode, ident(ctype)))


####################################################################################################
# Generation of a structure at runtime.
# Access to fields must be done via a specific getter or setter.

type

  # Unit to use.
  Unit = enum unit8, unit16, unit32, unit64

  # Position of a field in a unit.
  FieldPosition = tuple[row, start, length: int]

  # Description of the structure.
  Structure* = object
    names: seq[string]                        # Original names.
    positions: Table[string, FieldPosition]   # Mapping name (in lower case) => Position.
    # Storage.
    case unit: Unit:
    of unit8:
      s8: seq[uint8]
    of unit16:
      s16: seq[uint16]
    of unit32:
      s32: seq[uint32]
    of unit64:
      s64: seq[uint64]

#---------------------------------------------------------------------------------------------------

proc createStructVar*(diagram: string): Structure =
  ## Create a variable for the structure described by "diagram".

  var rawStruct = parse(diagram)

  # Allocate the storage for the structure.
  case rawStruct.size
  of 8:
    result = Structure(unit: unit8)
    result.s8.setLen(rawStruct.rows.len)
  of 16:
    result = Structure(unit: unit16)
    result.s16.setLen(rawStruct.rows.len)
  of 32:
    result = Structure(unit: unit32)
    result.s32.setLen(rawStruct.rows.len)
  of 64:
    result = Structure(unit: unit64)
    result.s64.setLen(rawStruct.rows.len)
  else:
    raise newException(ValueError, "Internal error")

  # Build the table mapping field names to positions.
  for i, row in rawStruct.rows:
    var offset = 0
    for field in row:
      result.names.add(field.name)
      result.positions[field.name.toLower] = (row: i, start: offset, length: field.length)
      inc offset, field.length

#---------------------------------------------------------------------------------------------------

proc get*(struct: Structure; fieldName: string): uint64 =
  ## Return the value of field "fieldName" in a structure.
  ## The value type is "uint64" and should be converted to another type if needed.

  # Get the position of the field.
  var row, start, length: int
  try:
    (row, start, length) = struct.positions[fieldName.toLower]
  except KeyError:
    raise newException(FieldError, "Invalid field: " & fieldName)

  let mask = 1 shl length - 1
  let endpos = start + length - 1

  case struct.unit
  of unit8:
    result = (struct.s8[row] and mask.uint8 shl (7 - endpos)) shr (7 - endpos)
  of unit16:
    result = (struct.s16[row] and mask.uint16 shl (15 - endpos)) shr (15 - endpos)
  of unit32:
    result = (struct.s32[row] and mask.uint32 shl (31 - endpos)) shr (31 - endpos)
  of unit64:
    result = (struct.s64[row] and mask.uint64 shl (63 - endpos)) shr (63 - endpos)

#---------------------------------------------------------------------------------------------------

proc set*(struct: var Structure; fieldName: string; value: SomeInteger) =
  ## Set the value of the field "fieldName" in a structure.

  # Get the position of the field.
  var row, start, length: int
  try:
    (row, start, length) = struct.positions[fieldName.toLower]
  except KeyError:
    raise newException(FieldError, "Invalid field: " & fieldName)

  let mask = 1 shl length - 1
  let endpos = start + length - 1
  let value = value and mask   # Make sure that the value fits in the field.

  case struct.unit
  of unit8:
    struct.s8[row] =
      struct.s8[row] and not (mask.uint8 shl (7 - endpos)) or (value.uint8 shl (7 - endpos))
  of unit16:
    struct.s16[row] =
      struct.s16[row] and not (mask.uint16 shl (15 - endpos)) or (value.uint16 shl (15 - endpos))
  of unit32:
    struct.s32[row] =
      struct.s32[row] and not (mask.uint32 shl (31 - endpos)) or (value.uint32 shl (31 - endpos))
  of unit64:
    struct.s64[row] =
      struct.s64[row] and not (mask.uint64 shl (63 - endpos)) or (value.uint64 shl (63 - endpos))

#---------------------------------------------------------------------------------------------------

iterator fields*(struct: Structure): uint64 =
  ## Yield the values of the successive fields of a structure

  for name in struct.positions.keys:
    yield struct.get(name)

#---------------------------------------------------------------------------------------------------

iterator fieldPairs*(struct: Structure): tuple[key: string, val: uint64] =
  ## Yield names and values of the successive fields of a structure

  for name in struct.names:
    yield (name, struct.get(name))

#---------------------------------------------------------------------------------------------------

proc `$`*(struct: Structure): string =
  ## Produce a representation of a structure.

  result = "("
  for name in struct.names:
    result.addSep(", ", 1)
    result.add(name & ": " & $struct.get(name))
  result.add(')')

#---------------------------------------------------------------------------------------------------

proc toHex(struct: Structure): string =
  ## Return the hexadecimal representation of a structure.

  case struct.unit
  of unit8:
    for row in struct.s8:
      result.add(row.toHex(2))
  of unit16:
    for row in struct.s16:
      result.add(row.toHex(4))
  of unit32:
    for row in struct.s32:
      result.add(row.tohex(8))
  of unit64:
    for row in struct.s64:
      result.add(row.toHex(16))

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  # Creation of a structure at compile time.
  # ----------------------------------------

  # Create the type "Header" to represent the structure described by "Diagram".
  createStructType(Diagram, "Header")

  # Declare a variable of type Header and initialize its fields.
  var header1 = Header(ID: 30791, QR: 0, Opcode: 15, AA: 0, TC: 1, RD: 1, RA: 1, Z: 3, RCODE:15,
                       QDCOUNT: 21654, ANCOUNT: 57646, NSCOUNT: 7153, ARCOUNT: 27044)
  echo "Header from a structure defined at compile time:"
  echo header1
  echo ""

  # Of course, it is possible to loop on the fields.
  echo "Same fields/values retrieved with an iterator:"
  for name, value in header1.fieldPairs:
    echo name, ": ", value
  echo ""

  # Hexadecimal representation.
  var h = ""
  var p = cast[ptr UncheckedArray[typeof(header1.ID)]](addr(header1))
  for i in 0..<(sizeof(header1) div sizeof(typeof(header1.ID))):
    h.add(p[i].toHex(4))
  echo "Hexadecimal representation: ", h
  echo ""


  # Creation of a structure at runtime.
  # -----------------------------------

  # Declare a variable initalized with the structure created at runtime.
  var header2 = createStructVar(Diagram)

  header2.set("ID", 30791)
  header2.set("QR", 0)
  header2.set("Opcode", 15)
  header2.set("AA", 0)
  header2.set("TC", 1)
  header2.set("RD", 1)
  header2.set("RA", 1)
  header2.set("Z", 3)
  header2.set("RCODE", 15)
  header2.set("QDCOUNT", 21654)
  header2.set("ANCOUNT", 57646)
  header2.set("NSCOUNT", 7153)
  header2.set("ARCOUNT", 27044)

  echo "Header from a structure defined at runtime: "
  echo header2
  echo ""

  # List fields using the "fieldPairs" iterator.
  echo "Same fields/values retrieved with an iterator:"
  for name, val in header2.fieldPairs():
    echo name, ": ", val
  echo ""

  # Hexadecimal representation.
  echo "Hexadecimal representation: ", header2.toHex()
