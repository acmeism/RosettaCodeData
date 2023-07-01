# create a Stack
def Stack: {stack: []};

# check an object is a Stack
def isStack:
  type == "object" and has("stack") and (.stack|type) == "array";

def pop:
  if .stack|length == 0 then "pop: stack is empty" | error
  else {stack: .stack[1:], item: .stack[0]]
  end;

def push($x):
  .stack = [$x] + .stack | .item = null;

def size:
  .stack | length;

def isEmpty:
  size == 0;
