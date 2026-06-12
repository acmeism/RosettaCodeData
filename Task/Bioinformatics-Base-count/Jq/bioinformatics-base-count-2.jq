def read_seq:
  reduce inputs as $line (""; . + $line);

# Emit a bow of the letters in the input string
def counts:
  . as $in | bow(range(0;length) | $in[.:.+1]);

def pp_counts:
  "BASE COUNTS:",
   (counts | to_entries | sort[] | "    \(.key):  \(.value | lpad(6;" "))"),
   "Total: \(length|lpad(7;" "))" ;

def pp_sequence($cols):
  range(0; length / $cols) as $i
    | "\($i*$cols | lpad(5; " ")): " +  .[ $i * $cols : ($i+1) * $cols] ;
