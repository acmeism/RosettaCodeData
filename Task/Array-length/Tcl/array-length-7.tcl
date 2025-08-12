# The ''lindex''  command returns a single item at a given index of a list

set c [lindex $fruit 2] ;#  "cherries"  (0-based index)

# The ''lrange'' command returns a given range of items from a list, as a new list.

set A [lrange $fruit 0 2] ;#   {apples oranges cherries} (list)

# An empty list is not necessarily an empty string:
set var { }  ;#  $var => " ",  but [llength $var] => 0
