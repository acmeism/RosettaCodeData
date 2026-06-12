include "rc-singly-linked-list" {search: "."}; # see [[Singly-linked_list/Element_definition#jq]]

# Convert the SLL to a stream of its values:
def items: while(has("item"); .next) | .item;

# Convert an array (possibly empty) into a SLL
def SLL:
  . as $in
  | reduce range(length-1; -1; -1) as $j ({next: null};
      insert($in[$j]) );

# Output an array
def reverse(stream):
  reduce stream as $x ([]; [$x] + .);

def reverse_singly_linked_list:
  reverse(items) | SLL;

def example: [1,2] | SLL;

example | reverse_singly_linked_list | items
