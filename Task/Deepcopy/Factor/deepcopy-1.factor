USING: accessors arrays io kernel named-tuples prettyprint
sequences sequences.deep ;

! Define a simple class
TUPLE: foo bar baz ;

! Allow instances of foo to be modified like an array
INSTANCE: foo named-tuple

! Create a foo object composed of mutable objects
V{ 1 2 3 } V{ 4 5 6 } [ clone ] bi@ foo boa

! create a copy of the reference to the object
dup

! create a deep copy from this copy
>array [ clone ] deep-map T{ foo } like

! print them both
"Before modification:" print [ [ . ] bi@ ] 2keep nl

! modify the deep copy
[ -1 suffix! ] change-bar

! print them both again
"After modification:" print [ . ] bi@
