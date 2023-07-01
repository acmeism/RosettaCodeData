# Left-to-right evaluation
def eval:
  if type == "array" then
    if length == 0 then null
    else .[-1] |= eval
    | if length == 1 then .[0]
      else (.[:-2] | eval) as $v
      | if   .[-2] == "*" then $v * .[-1]
        elif .[-2] == "/" then $v / .[-1]
        elif .[-2] == "+" then $v + .[-1]
        elif .[-2] == "-" then $v - .[-1]
        else tostring|error
	end
      end
    end
  else .
  end;

def eval(String):
  {remainder: String}
  | Expr.result
  | eval;
