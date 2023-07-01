# If the input is a valid representation of a binary string
# then pass it along:
def check_binary:
  . as $a
  | reduce .[] as $x
    ($a;
     if $x | (type == "number" and . == floor
              and 0 <= . and . <= 255) then $a
     else error("\(.) is an invalid representation of a byte")
     end );
