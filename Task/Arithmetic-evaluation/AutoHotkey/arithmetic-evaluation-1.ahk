/*
hand coded recursive descent parser
expr	: term ( ( PLUS | MINUS )  term )* ;
term	: factor ( ( MULT | DIV ) factor )* ;
factor	: NUMBER | '(' expr ')';
*/

calcLexer := makeCalcLexer()
string := "((3+4)*(7*9)+3)+4"
tokens := tokenize(string, calcLexer)
msgbox % printTokens(tokens)
ast := expr()
msgbox % printTree(ast)
msgbox % expression := evalTree(ast)
filedelete expression.ahk
fileappend, % "msgbox % " expression, expression.ahk
run, expression.ahk
return


expr()
{
  global tokens
  ast := object(1, "expr")
  if node := term()
    ast._Insert(node)
  loop
  {
    if peek("PLUS") or peek("MINUS")
    {
      op := getsym()
      newop := object(1, op.type, 2, op.value)
      node := term()
      ast._Insert(newop)
      ast._Insert(node)
    }
    Else
      Break
  }
  return ast
}

term()
{
  global tokens
  tree := object(1, "term")
  if node := factor()
    tree._Insert(node)
  loop
  {
    if  peek("MULT") or peek("DIV")
    {
      op := getsym()
      newop := object(1, op.type, 2, op.value)
      node := factor()
      tree._Insert(newop)
      tree._Insert(node)
    }
    else
      Break
  }
  return tree
}

factor()
{
  global tokens
  if peek("NUMBER")
  {
    token := getsym()
    tree := object(1, token.type, 2, token.value)
    return tree
  }
  else if  peek("OPEN")
  {
    getsym()
    tree := expr()
    if  peek("CLOSE")
    {
      getsym()
      return tree
    }
    else
      error("miss closing parentheses ")
  }
  else
    error("no factor found")
}

peek(type, n=1)
{
global tokens
  if (tokens[n, "type"] == type)
  return 1
}

getsym(n=1)
{
global tokens
return token := tokens._Remove(n)
}

error(msg)
{
global tokens
msgbox % msg " at:`n" printToken(tokens[1])
}


printTree(ast)
{
if !ast
return

n := 0
  loop
  {
  n += 1
    if !node := ast[n]
      break
    if !isobject(node)
      treeString .= node
    else
      treeString .= printTree(node)
  }
  return ("(" treeString ")" )
}

evalTree(ast)
{
if !ast
return

n := 1
  loop
  {
  n += 1
    if !node := ast[n]
      break
    if !isobject(node)
      treeString .= node
    else
      treeString .= evalTree(node)
  }
if (n == 3)
return treeString
  return ("(" treeString ")" )
}

#include calclex.ahk
