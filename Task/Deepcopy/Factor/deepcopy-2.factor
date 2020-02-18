! Create a foo object composed of mutable objects
V{ 1 2 3 } V{ 4 5 6 } [ clone ] bi@ foo boa

! create a copy of the reference to the object
dup

! create a deep copy from this copy
object>bytes bytes>object

! print them both
"Before modification:" print [ [ . ] bi@ ] 2keep nl

! modify the deep copy
[ -99 suffix! ] change-bar

"After modification:" print [ . ] bi@
