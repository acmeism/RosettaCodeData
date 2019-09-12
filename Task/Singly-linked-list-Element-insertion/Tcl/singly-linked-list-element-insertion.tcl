proc insertIntoList {existingList predecessor newElement} {
  upvar $existingList exList
  set exList [linsert $exList [expr [lsearch -exact $exList $predecessor] + 1] $newElement]
}

set list {A B}
insertIntoList list A C
puts $list
