# Emit (input)^i where input and i are non-negative decimal integers,
# represented as numbers and/or strings.
def long_power(i):
  def power(i):
    tostring as $self
    | (i|tostring) as $i
    | if   $i == "0" then "1"
      elif $i == "1" then $self
      elif $self == "0" then "0"
      else reduce range(1;i) as $_ ( $self; long_multiply(.; $self) )
      end;

  (i|tonumber) as $i
  | if $i < 4 then power($i)
    else ($i|sqrt|floor) as $j
    | ($i - $j*$j) as $k
    | long_multiply( power($j) | power($j) ; power($k) )
  end ;
