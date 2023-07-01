set var 3
set pointer var; # assign name "var" not value 3
set pointer;     # returns "var"
set $pointer;    # returns 3
set $pointer 42; # variable var now has value 42
