# ln(1+x) = x - x^2 / 2 + ...
def ln_1px:
  def c: if . % 2 == 0 then -1 else 1 end;
  . as $i | if $i == 0 then 0 else ($i|c) / $i  end;
