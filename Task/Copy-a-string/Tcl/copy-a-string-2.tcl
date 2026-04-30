set A  "a string"

set B $A   ; # B is a reference to the string

Set C "$A" ; # a new string is created

set D "This is $C"  ; # the string bound to C is copied into a new string.


# the append command is internally optimized
# for adding to the end of a string or list
# as is string index for returning a letter

# reverse a string
proc reverse {s} {
  set len [string length $s]
  set r ""
  for { set i $len} { $i >= 0} {incr i -1} {
        append r [string index $s $i]
  }
  return $r
}

set a 12345

set b [reverse $a]

puts stdout "b: $b"
