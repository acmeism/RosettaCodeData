# Counting the first line in the file as line 1,
#  attempt to remove "number" lines from line number "start" onwards:
def remove_lines(start; number):
  (start+number - 1) as $max
  | reduce split("\n")[] as $line
      ( [0, []];
       .[0] += 1
       | .[0] as $i
       | if start <= $i and $i <= $max then . else .[1] += [$line] end)
  | .[0] as $count
  | .[1]
  | join("\n")
  | (if $count < $max then "WARNING: there are only \($count) lines" else empty end), .;

remove_lines($start|tonumber; $number|tonumber)
