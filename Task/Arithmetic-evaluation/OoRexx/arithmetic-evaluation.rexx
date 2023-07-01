expressions = .array~of("2+3", "2+3/4", "2*3-4", "2*(3+4)+5/6", "2 * (3 + (4 * 5 + (6 * 7) * 8) - 9) * 10", "2*-3--4+-.25")
loop input over expressions
    expression = createExpression(input)
    if expression \= .nil then
        say 'Expression "'input'" parses to "'expression~string'" and evaluates to "'expression~evaluate'"'
end


-- create an executable expression from the input, printing out any
-- errors if they are raised.
::routine createExpression
  use arg inputString
--  signal on syntax
  return .ExpressionParser~parseExpression(inputString)

syntax:
   condition = condition('o')
   say condition~errorText
   say condition~message
   return .nil


-- a base class for tree nodes in the tree
-- all nodes return some sort of value.  This can be constant,
-- or the result of additional evaluations
::class evaluatornode
-- all evaluation is done here
::method evaluate abstract

-- node for numeric values in the tree
::class constant
::method init
  expose value
  use arg value

::method evaluate
  expose value
  return value

::method string
  expose value
  return value

-- node for a parenthetical group on the tree
::class parens
::method init
  expose subexpression
  use arg subexpression

::method evaluate
  expose subexpression
  return subexpression~evaluate

::method string
  expose subexpression
  return "("subexpression~string")"

-- base class for binary operators
::class binaryoperator
::method init
  expose left right
  -- the left and right sides are set after the left and right sides have
  -- been resolved.
  left = .nil
  right = .nil

-- base operation
::method evaluate
  expose left right
  return self~operation(left~evaluate, right~evaluate)

-- the actual operation of the node
::method operation abstract
::method symbol abstract
::method precedence abstract

-- display an operator as a string value
::method string
  expose left right
  return '('left~string self~symbol right~string')'

::attribute left
::attribute right

::class addoperator subclass binaryoperator
::method operation
  use arg left, right
  return left + right

::method symbol
  return "+"

::method precedence
  return 1

::class subtractoperator subclass binaryoperator
::method operation
  use arg left, right
  return left - right

::method symbol
  return "-"

::method precedence
  return 1

::class multiplyoperator subclass binaryoperator
::method operation
  use arg left, right
  return left * right

::method symbol
  return "*"

::method precedence
  return 2

::class divideoperator subclass binaryoperator
::method operation
  use arg left, right
  return left / right

::method symbol
  return "/"

::method precedence
  return 2

-- a class to parse the expression and build an evaluation tree
::class expressionParser
-- create a resolved operand from an operator instance and the top
-- two entries on the operand stack.
::method createNewOperand class
  use strict arg operator, operands
  -- the operands are a stack, so they are in inverse order current
  operator~right = operands~pull
  operator~left = operands~pull
  -- this goes on the top of the stack now
  operands~push(operator)

::method parseExpression class
  use strict arg inputString
  -- stacks for managing the operands and pending operators
  operands = .queue~new
  operators = .queue~new
  -- this flags what sort of item we expect to find at the current
  -- location
  afterOperand = .false

  loop currentIndex = 1 to inputString~length
      char = inputString~subChar(currentIndex)
      -- skip over whitespace
      if char == ' ' then iterate currentIndex
      -- If the last thing we parsed was an operand, then
      -- we expect to see either a closing paren or an
      -- operator to appear here
      if afterOperand then do
          if char == ')' then do
              loop while \operators~isempty
                  operator = operators~pull
                  -- if we find the opening paren, replace the
                  -- top operand with a paren group wrapper
                  -- and stop popping items
                  if operator == '(' then do
                     operands~push(.parens~new(operands~pull))
                     leave
                  end
                  -- collapse the operator stack a bit
                  self~createNewOperand(operator, operands)
              end
              -- done with this character
              iterate currentIndex
          end
          afterOperand = .false
          operator = .nil
          if char == "+" then operator = .addoperator~new
          else if char == "-" then operator = .subtractoperator~new
          else if char == "*" then operator = .multiplyoperator~new
          else if char == "/" then operator = .divideoperator~new
          if operator \= .nil then do
              loop while \operators~isEmpty
                  top = operators~peek
                  -- start of a paren group stops the popping
                  if top == '(' then leave
                  -- or the top operator has a lower precedence
                  if top~precedence < operator~precedence then leave
                  -- process this pending one
                  self~createNewOperand(operators~pull, operands)
              end
              -- this new operator is now top of the stack
              operators~push(operator)
              -- and back to the top
              iterate currentIndex
          end
          raise syntax 98.900 array("Invalid expression character" char)
      end
      -- if we've hit an open paren, add this to the operator stack
      -- as a phony operator
      if char == '(' then do
          operators~push('(')
          iterate currentIndex
      end
      -- not an operator, so we have an operand of some type
      afterOperand = .true
      startindex = currentIndex
      -- allow a leading minus sign on this
      if inputString~subchar(currentIndex) == '-' then
          currentIndex += 1
      -- now scan for the end of numbers
      loop while currentIndex <= inputString~length
          -- exit for any non-numeric value
          if \inputString~matchChar(currentIndex, "0123456789.") then leave
          currentIndex += 1
      end
      -- extract the string value
      operand = inputString~substr(startIndex, currentIndex - startIndex)
      if \operand~datatype('Number') then
          raise syntax 98.900 array("Invalid numeric operand '"operand"'")
      -- back this up to the last valid character
      currentIndex -= 1
      -- add this to the operand stack as a tree element that returns a constant
      operands~push(.constant~new(operand))
  end

  loop while \operators~isEmpty
      operator = operators~pull
      if operator == '(' then
          raise syntax 98.900 array("Missing closing ')' in expression")
      self~createNewOperand(operator, operands)
  end
  -- our entire expression should be the top of the expression tree
  expression = operands~pull
  if \operands~isEmpty then
      raise syntax 98.900 array("Invalid expression")
  return expression
