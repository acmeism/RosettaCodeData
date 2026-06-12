# Generic utilities
def count(s): reduce s as $x (0; .+1);

# A constructor for SLL:
def new($item): {$item, next: null};

# Append a single item to an array or SLL.
# If the input is {} or a SLL, the output is a SLL
# If the input is null or an array, the output is an array
def append($item):
  def a: if .next then .next |= a else .next=new($item) end;
  if . == null then [$item]
  elif . == {} then new($item)
  else a
  end;

# Append a stream of items using `append/1`
def append_items(stream):
  reduce stream as $item (.; append($item));

# Produce a stream of items
def poly_items:
  if type == "array" then .[]
  else .item, (select(.next).next|poly_items)
  end;

def poly_length:
  if type == "array" then length
  else count(poly_items)
  end;

# Output: the stream of items in reversed order
def poly_reversed:
  if type == "array" then .[range(length-1; -1; -1)]
  else [poly_items] | reverse[]
  end;

# Two representations of Days of the Week (dow) and of colors:
def dow: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
def sll_dow: {} | append_items(dow[]);

def colors: [ "red", "orange", "yellow", "green", "blue", "indigo", "violet"];
def sll_colors: {} | append_items(colors[]);

def poly_task:
  poly_length as $length
  | "All the elements:", poly_items,
    "",
    "The first, fourth, and fifth elements:",
    ((0, 3, 4) as $i
     | "For i=\($i): \(nth($i; poly_items))" ),
     "",
    "The last, fourth to last, and fifth to last elements:",
    ((0, 3, 4) as $i
     | "For i=\($i): \(nth($i; poly_reversed) )" );


"For days of the week:",
"For arrays:", (dow | poly_task),
"",
"For singly-linked lists:", (sll_dow | poly_task),
"\n",
"For colors:",
"For arrays:", (colors | poly_task),
"",
"For singly-linked lists:", (sll_colors | poly_task)
