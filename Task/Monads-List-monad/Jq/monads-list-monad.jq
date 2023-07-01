# Constructor:
def Monad($type; $value):
  {class: "Monad", $type, $value};

# Is the input a monad of type $Type?
def is_monad($Type):
  (type == "object")
  and (.class == "Monad")
  and (.type == $Type) ;

# input: a value consistent with the "List" monadic type (in practice, a JSON array)
# No checking is done here as the monadic type system is outside the scope of this entry.
def List::return:
  Monad("List"; .);

def List::bind(f):
  if is_monad("List")
  then .value |= f
  else error("List::bind error: monadic type of input is \(.type)")
  end;

# Two illustrative operations on JSON arrays
def increment: map(. + 1);
def double: map(. * 2);

def ml1:
  [3, 4, 5] | List::return;
def ml2:
  ml1 | List::bind(increment) | List::bind(double);

"\(ml1.value) -> \(ml2.value)"
