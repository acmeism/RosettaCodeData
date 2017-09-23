def demo:
  "abc" as $s    # assignment of a string to a variable
  | $s as $t     # $t points to the same string as $s
  | "def" as $s  # This $s shadows the previous $s
  | $t           # $t still points to "abc"
;

demo
