def elementwise2( operator; other ):
  def pow(i): . as $in | reduce range(0;i) as $i (1; .*$in);
  def operation(x; op; y):
    [x,y] | op as $op
    | if $op == "+" then x+y
      elif $op == "-" then x-y
      elif $op == "*" then x*y
      elif $op == "/" then x/y
      elif $op == "%" then x%y
      elif $op == "//" then x/y|floor
      elif $op == "**" or $op == "^" or $op == "pow" then x|pow(y)
      else $op
      end;

  length as $rows
  | if $rows == 0 then .
    else . as $self
    | other as $other
    | ($self[0]|length) as $cols
    | reduce range(0; $rows) as $i
        ([]; reduce range(0; $cols) as $j
          (.; .[$i][$j] = operation($self[$i][$j]; operator; $other[$i][$j] ) ) )
    end;
