import ast_lexer

type NodeKind* = enum
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

type Node* = ref object
  left*: Node
  right*: Node
  case kind*: NodeKind
  of nString: stringVal*: string
  of nInteger: intVal*: int
  of nIdentifier: name*: string
  else: nil

type Operator = range[tokMult..tokOr]

const

  Precedences: array[Operator, int] = [13,  # tokMult
                                       13,  # tokDiv
                                       13,  # tokMod
                                       12,  # tokAdd
                                       12,  # tokSub
                                       10,  # tokLess
                                       10,  # tokLessEq
                                       10,  # tokGreater
                                       10,  # tokGreaterEq
                                        9,  # tokEq
                                        9,  # tokNeq
                                       14,  # tokNot
                                       -1,  # tokAssign
                                        5,  # tokAnd
                                        4]  # tokOr
  UnaryPrecedence = 14
  BinaryOperators = {tokMult, tokDiv, tokMod, tokAdd, tokSub, tokLess, tokLessEq,
                    tokGreater, tokGreaterEq, tokEq, tokNotEq, tokAnd, tokOr}

  # Mapping of operators from TokenKind to NodeKind.
  NodeKinds: array[Operator, NodeKind] = [nMultiply, nDivide, nMod, nAdd, nSubtract,
                                          nLess, nLessEqual, nGreater, nGreaterEqual,
                                          nEqual, nNotEqual, nNot, nAssign, nAnd, nOr]

type SyntaxError* = object of CatchableError


####################################################################################################

template expect(token: Token; expected: TokenKind; errmsg: string) =
  ## Check if a token is of the expected kind.
  ## Raise a SyntaxError if this is not the case.
  if token.kind != expected:
    raise newException(SyntaxError, "line " & $token.ln & ": " & errmsg)
  token = lexer.next()

#---------------------------------------------------------------------------------------------------

proc newNode*(kind: NodeKind; left: Node; right: Node = nil): Node =
  ## Create a new node with given left and right children.
  result = Node(kind: kind, left: left, right: right)

#---------------------------------------------------------------------------------------------------

# Forward reference.
proc parExpr(lexer: var Lexer; token: var Token): Node

#---------------------------------------------------------------------------------------------------

proc expr(lexer: var Lexer; token: var Token; p: int): Node =
  ## Parse an expression.

  case token.kind

  of tokLPar:
    result = parExpr(lexer, token)

  of tokAdd, tokSub, tokNot:
    # Unary operators.
    let savedToken = token
    token = lexer.next()
    let e = expr(lexer, token, UnaryPrecedence)
    if savedToken.kind == tokAdd:
      result = e
    else:
      result = newNode(if savedToken.kind == tokSub: nNegate else: nNot, e)

  of tokIdent:
    result = Node(kind: nIdentifier, name: token.ident)
    token = lexer.next()

  of tokInt:
    result = Node(kind:nInteger, intVal: token.intVal)
    token = lexer.next()

  of tokChar:
    result = Node(kind:nInteger, intVal: ord(token.charVal))
    token = lexer.next()

  else:
    raise newException(SyntaxError, "Unexpected symbol at line " & $token.ln)

  # Process the binary operators in the expression.
  while token.kind in BinaryOperators and Precedences[token.kind] >= p:
    let savedToken = token
    token = lexer.next()
    let q = Precedences[savedToken.kind] + 1  # No operator is right associative.
    result = newNode(NodeKinds[savedToken.kind], result, expr(lexer, token, q))

#---------------------------------------------------------------------------------------------------

proc parExpr(lexer: var Lexer; token: var Token): Node =
  ## Parse a parenthetized expression.
  token.expect(tokLPar, "'(' expected")
  result = expr(lexer, token, 0)
  token.expect(tokRPar, "')' expected")

#---------------------------------------------------------------------------------------------------

proc stmt(lexer: var Lexer; token: var Token): Node =
  ## Parse a statement.

  case token.kind:

  of tokIf:
    token = lexer.next()
    let e = parExpr(lexer, token)
    let thenNode = stmt(lexer, token)
    var elseNode: Node = nil
    if token.kind == tokElse:
      token = lexer.next()
      elseNode = stmt(lexer, token)
    result = newNode(nIf, e, newNode(nIf, thenNode, elseNode))

  of tokPutc:
    token = lexer.next()
    result = newNode(nPrtc, parExpr(lexer, token))
    token.expect(tokSemi, "';' expected")

  of tokPrint:
    token = lexer.next()
    token.expect(tokLPar, "'(' expected")
    while true:
      var e: Node
      if token.kind == tokString:
        e = newNode(nPrts, Node(kind: nString, stringVal: token.stringVal))
        token = lexer.next()
      else:
        e = newNode(nPrti, expr(lexer, token, 0))
      result = newNode(nSequence, result, e)
      if token.kind == tokComma:
        token = lexer.next()
      else:
        break
    token.expect(tokRPar, "')' expected")
    token.expect(tokSemi, "';' expected")

  of tokSemi:
    token = lexer.next()

  of tokIdent:
    let v = Node(kind: nIdentifier, name: token.ident)
    token = lexer.next()
    token.expect(tokAssign, "'=' expected")
    result = newNode(nAssign, v, expr(lexer, token, 0))
    token.expect(tokSemi, "';' expected")

  of tokWhile:
    token = lexer.next()
    let e = parExpr(lexer, token)
    result = newNode(nWhile, e, stmt(lexer, token))

  of tokLBrace:
    token = lexer.next()
    while token.kind notin {tokRBrace, tokEnd}:
      result = newNode(nSequence, result, stmt(lexer, token))
    token.expect(tokRBrace, "'}' expected")

  of tokEnd:
    discard

  else:
    raise newException(SyntaxError, "Unexpected symbol at line " & $token.ln)

#---------------------------------------------------------------------------------------------------

proc parse*(code: string): Node =
  ## Parse the code provided.

  var lexer = initLexer(code)
  var token = lexer.next()
  while true:
    result = newNode(nSequence, result, stmt(lexer, token))
    if token.kind == tokEnd:
      break

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  import os, strformat, strutils

  proc printAst(node: Node) =
    ## Print tha AST in linear form.

    if node.isNil:
      echo ';'

    else:
      stdout.write &"{$node.kind:<14}"
      case node.kind
      of nIdentifier:
        echo node.name
      of nInteger:
        echo node.intVal
      of nString:
        # Need to escape and to replace hexadecimal \x0A by \n.
        echo escape(node.stringVal).replace("\\x0A", "\\n")
      else:
        echo ""
        node.left.printAst()
        node.right.printAst()


  let code = if paramCount() < 1: stdin.readAll() else: paramStr(1).readFile()
  let tree = parse(code)
  tree.printAst()
