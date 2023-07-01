 def new($item; $next):
  if $next | (.==null or is_singly_linked_list)
  then {$item, $next}
  else "new(_;_) called with invalid SLL: \($next)" | error
  end;

# A constructor:
def new($x): new($x; null);

def insert($x):
  if is_empty_singly_linked_list then {item: $x, next: null}
  else .next |= new($x; .)
  end;
