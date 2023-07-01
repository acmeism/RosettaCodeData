def sum(lo; hi; term):
  reduce range(lo; hi+1) as $i (0; . + ($i|term));

# The task:
sum(1;100;1/.)
