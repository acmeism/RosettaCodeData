import os, strutils, streams, tables

import ast_parser

type

  ValueKind = enum valNil, valInt, valString

  # Representation of a value.
  Value = object
    case kind: ValueKind
    of valNil: nil
    of valInt: intVal: int
    of valString: stringVal: string

  # Range of binary operators.
  BinaryOperator = range[nMultiply..nOr]

# Table of variables.
var variables: Table[string, Value]

type RunTimeError = object of CatchableError

#---------------------------------------------------------------------------------------------------

template newInt(val: typed): Value =
  ## Create an integer value.
  Value(kind: valInt, intVal: val)

#---------------------------------------------------------------------------------------------------

proc interp(node: Node): Value =
  ## Interpret code starting at "node".

  if node.isNil:
    return Value(kind: valNil)

  case node.kind

  of nInteger:
    result = Value(kind: valInt, intVal: node.intVal)

  of nIdentifier:
    if node.name notin variables:
      raise newException(RunTimeError, "Variable {node.name} is not initialized.")
    result = variables[node.name]

  of nString:
    result = Value(kind: valString, stringVal: node.stringVal)

  of nAssign:
    variables[node.left.name] = interp(node.right)

  of nNegate:
    result = newInt(-interp(node.left).intVal)

  of nNot:
    result = newInt(not interp(node.left).intVal)

  of BinaryOperator.low..BinaryOperator.high:

    let left = interp(node.left)
    let right = interp(node.right)

    case BinaryOperator(node.kind)
    of nMultiply:
      result = newInt(left.intVal * right.intVal)
    of nDivide:
      result = newInt(left.intVal div right.intVal)
    of nMod:
      result = newInt(left.intVal mod right.intVal)
    of nAdd:
      result = newInt(left.intVal + right.intVal)
    of nSubtract:
      result = newInt(left.intVal - right.intVal)
    of nLess:
      result = newInt(ord(left.intVal < right.intVal))
    of nLessEqual:
      result = newInt(ord(left.intVal <= right.intVal))
    of nGreater:
      result = newInt(ord(left.intVal > right.intVal))
    of nGreaterEqual:
      result = newInt(ord(left.intVal >= right.intVal))
    of nEqual:
      result = newInt(ord(left.intVal == right.intVal))
    of nNotEqual:
      result = newInt(ord(left.intVal != right.intVal))
    of nAnd:
      result = newInt(left.intVal and right.intVal)
    of nOr:
      result = newInt(left.intVal or right.intVal)

  of nIf:
    if interp(node.left).intVal != 0:
      discard interp(node.right.left)
    else:
      discard interp(node.right.right)

  of nWhile:
    while interp(node.left).intVal != 0:
      discard interp(node.right)

  of nPrtc:
    stdout.write(chr(interp(node.left).intVal))

  of nPrti:
    stdout.write(interp(node.left).intVal)

  of nPrts:
    stdout.write(interp(node.left).stringVal)

  of nSequence:
    discard interp(node.left)
    discard interp(node.right)

#---------------------------------------------------------------------------------------------------

import re

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
    str = fields[1].replacef(re"([^\\])(\\n)", "$1\n").replace(r"\\", r"\").replace("\"", "")
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

if paramCount() < 1:
  stream = newFileStream(stdin)
else:
  stream = newFileStream(paramStr(1))
  toClose = true

let ast = loadAst(stream)
if toClose: stream.close()

discard ast.interp()
