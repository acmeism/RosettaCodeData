foo();              # Call foo on the null list
&foo();             # Ditto
foo($arg1, $arg2);  # Call foo on $arg1 and $arg2
&foo($arg1, $arg2); # Ditto; ignores prototypes
