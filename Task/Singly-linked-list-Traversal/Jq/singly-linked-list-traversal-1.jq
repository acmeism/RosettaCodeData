# Produce a stream of the items in the input SLL.
def items:
  while(.; .next) | .item;

def to_singly_linked_list(s):
  reduce ([s]|reverse[]) as $item (null; {$item, next:.});

# If f evaluates to empty at any item, that item is removed;
# if f evaluates to more than one item, all are added separately.
def map_singly_linked_list(f): to_singly_linked_list( items | f );
