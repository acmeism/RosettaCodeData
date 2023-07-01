# Evaluate $Expr in the context of {A,B,....}
def eval($Expr):
  if   $Expr|type == "boolean" then $Expr
  elif $Expr|type == "string" then getpath([$Expr])
  elif $Expr|length == 1 then eval($Expr[0])
  elif $Expr|(length == 2 and first == "not") then eval($Expr[-1])|not
  elif $Expr|(length == 3 and .[1] == "or")  then eval($Expr[0]) or eval($Expr[2])
  elif $Expr|(length == 3 and .[1] == "xor")
  then eval($Expr[0]) as $x
  |    eval($Expr[2]) as $y
  | ($x and ($y|not)) or ($y and ($x|not))
  elif $Expr|(length == 3 and .[1] == "and") then  eval($Expr[0]) and eval($Expr[2])
  elif $Expr|(length == 3 and .[1] == "=>")  then (eval($Expr[0])|not) or eval($Expr[2])
  else $Expr | error
  end;
