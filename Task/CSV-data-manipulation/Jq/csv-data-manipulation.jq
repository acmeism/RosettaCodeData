# Input: a single row
# Omit empty rows
def read_csv:
  if length>0 then split(",") else empty end ;

# Input: an array
# Output: the same array but with an additional summation column.
# If .[0] is a number, then it is assumed the entire row consists of numbers or numeric strings;
# otherwise, 0 is added
def add_sum:
  (if .[0] | type == "number" then (map(tonumber) | add) else 0 end) as $sum
  | . + [$sum] ;

# `tocsv` is only needed if fields should only be quoted by necessity:
def tocsv:
  map( if type == "string" and test("[,\"\r\n]") then "\"\(.)\"" else . end )
  | join(",");

( input | read_csv | . + ["SUM"] | @csv),
(inputs | read_csv | add_sum | @csv)
