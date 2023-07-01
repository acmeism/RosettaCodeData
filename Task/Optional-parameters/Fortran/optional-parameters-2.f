program UsingTest
  use ExampleOptionalParameter
  implicit none

  type(table_type) :: table

  ! create the table...

  ! sorting taking from column 1, not reversed, using internal
  ! default comparator
  call sort_table(table)

  ! the same as above, but in reversed order; we MUST specify
  ! the name of the argument since it is not given in the same
  ! order of the subroutine spec
  call sort_table(table, reverse=.true.)

  ! sort the table using a custom comparator
  call sort_table(table, my_cmp)
  ! or
  call sort_table(table, ordering=my_cmp)

  ! as above, but taking from column 2
  call sort_table(table, my_cmp, 2)
  ! or (swapping the order of args for fun)
  call sort_table(table, column=2, ordering=my_cmp)

  ! with custom comparator, column 2 and reversing...
  call sort_table(table, my_cmp, 2, .true.)
  ! of course we can swap the order of optional args
  ! by prefixing them with the name of the arg

  ! sort from column 2, with internal comparator
  call sort_table(table, column=2)

end program UsingTest
