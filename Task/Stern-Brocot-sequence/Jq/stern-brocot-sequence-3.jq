# Generate a stream of n integers beginning with 1,1...
def stern_brocot(n): A002487(n+1) | .[1:n+1][];

# Return the index (counting from 1) of n in the
# sequence starting with 1,1,...
def stern_brocot_index(n):
  A002487(-n) | length -1 ;

def index_task:
  (range(1;11), 100) as $i
  | "index of \($i) is \(stern_brocot_index($i))" ;

def gcd_task:
  A002487(1000)
  | . as $A
  | reduce range(0; length-1) as $i
      ( [];
        gcd( $A[$i]; $A[$i+1] ) as $gcd
        | if $gcd == 1 then . else . +  [$gcd] end)
  | if length == 0 then "GCDs are all 1"
    else "GCDs include \(.)" end ;


"First 15 integers of the Stern-Brocot sequence",
"as defined in the task description are:",
stern_brocot(15),
"",
"Using an index origin of 1:",
index_task,
"",
gcd_task
