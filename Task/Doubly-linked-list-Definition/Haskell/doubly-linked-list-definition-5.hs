procedure main ()
  dlist := DoubleList (5)
  every i := 4 to 1 by -1 do
    dlist.insert_at_head (i)
  every i := 6 to 10 do
    dlist.insert_at_tail (i)

  dlist.insert_after (3, 11)

  every node := dlist.head().traverse_forwards () do
    write (node.value)
end
