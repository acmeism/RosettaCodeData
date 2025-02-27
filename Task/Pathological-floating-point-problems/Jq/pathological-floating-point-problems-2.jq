# Given the balance in the prior year, compute the new balance in year n.
# Input: { e: m, c: n } representing m*e + n
def new_balance(n):
  if n == 0 then {e: 1, c: -1}
  else {e: (.e * n), c: (.c * n - 1) }
  end;

def balance(n):
  def e: 1|exp;
  reduce range(0;n) as $i ({}; new_balance($i) )
  | (.e * e) + .c;
