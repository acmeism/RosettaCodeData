# Input - a line number to read, counting from 1
# Output - a stream with 0 or 1 items
def read_line:
  . as $in
  | label $top
  | foreach inputs as $line
      (0; .+1; if . == $in then $line, break $top else empty end) ;
