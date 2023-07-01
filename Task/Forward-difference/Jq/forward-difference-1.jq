# If n is a non-negative number and if input is
# a (possibly empty) array of numbers,
# emit an array, even if the input list is too short:
def ndiff(n):
  if n==0 then .
  elif n == 1 then . as $in | [range(1;length) | $in[.] - $in[.-1]]
  else ndiff(1) | ndiff(n-1)
  end;
