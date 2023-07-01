# If n (the input) is an admissible number of coconuts with respect to
# the night-time squirreling away of the coconuts by "sailors" sailors, then give 1 to the
# monkey, let one sailor squirrel away (1/sailors) coconuts, and yield the remaining number;
# otherwise, return false:
def squirrel(sailors):
  def admissible:  if . then (. % sailors) == 1 else . end;

  if admissible then  . - ((. - 1) / sailors) - 1
  else false
  end;

def nighttime(sailors):
  reduce range(0; sailors) as $i (.; squirrel(sailors));

def morning(sailors):
  if . then (. % sailors) == 0
  else false
  end;

# Test whether the input is a valid number of coconuts with respect to the story:
def valid(sailors): nighttime(sailors) | morning(sailors);
