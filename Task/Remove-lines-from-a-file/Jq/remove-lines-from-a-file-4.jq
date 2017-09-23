# Counting the first line in the file as line 1, attempt to remove "number" lines from line
# number "start" onwards:
def remove_lines_streaming(start; number):
  (start+number - 1) as $max
  # In the following line, null will serve to signal EOF so that the warning can be emitted.
  | foreach (inputs,null) as $line
      ( 0;
       . += 1;
       if $line == null then # EOF
         if . <= $max then "WARNING: there were only \(.) lines" else empty end
       elif start <= . and . <= $max then empty
       else $line
       end) ;

remove_lines_streaming($start|tonumber; $number|tonumber)
