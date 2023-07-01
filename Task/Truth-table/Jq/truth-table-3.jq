# input: a list of strings
# output: a stream of objects representing all possible true/false combinations
# Each object has the keys specified in the input.
def vars2tf:
  if length == 0 then {}
  else .[0] as $k
  | ({} | .[$k] = (true,false)) + (.[1:] | vars2tf)
  end;

# If the input is a string, then echo it;
# otherwise emit T or F
def TF:
  if type == "string" then .
  elif . then "T"
  else "F"
  end;

# Extract the distinct variable names from the parse tree.
def vars: [.. | strings | select(test("^[A-Z]"))] | unique;

def underscore:
  ., (length * "_");
