# Omit empty lines
def read_csv:
  split("\n")
  | map(if length>0 then split(",") else empty end) ;

# add_column(label) adds a summation column (with the given label) to
# the matrix representation of the CSV table, and assumes that all the
# entries in the body of the CSV file are, or can be converted to,
# numbers:
def add_column(label):
  [.[0] + [label],
   (reduce .[1:][] as $line
     ([]; ($line|map(tonumber)) as $line | . + [$line + [$line|add]]))[] ] ;

read_csv | add_column("SUM") | map(@csv)[]
