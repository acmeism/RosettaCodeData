def is_empty_singly_linked_list:
  type == "object" and .next == null and (has("item")|not);

def is_singly_linked_list:
  is_empty_singly_linked_list or
  (type == "object"
   and has("item")
   and (.next | ((. == null) or is_singly_linked_list)));

# Test for equality without checking for validity:
def equal_singly_linked_lists($x; $y):
   ($x|is_empty_singly_linked_list) as $xempty
   | if $xempty then ($y|is_empty_singly_linked_list)
     elif ($y|is_empty_singly_linked_list)
     then $xempty
     else ($x.item) == ($y.item)
          and equal_singly_linked_lists($x.next; $y.next)
     end;

# insert $x into the front of the SLL
def insert($x):
  if is_empty_singly_linked_list then {item: $x, next: null}
  else .next |= new($x; .)
  end;
