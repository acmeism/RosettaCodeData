module ExampleOptionalParameter
  ! use any module needed for the sort function(s)
  ! and all the interfaces needed to make the code work
  implicit none
contains

  subroutine sort_table(table, ordering, column, reverse)
    type(table_type), intent(inout) :: table
    integer, optional :: column
    logical, optional :: reverse
    optional :: ordering
    interface
       integer function ordering(a, b)
         type(table_element), intent(in) :: a, b
       end function ordering
    end interface

    integer :: the_column, i
    logical :: reversing
    type(table_row) :: rowA, rowB

    if ( present(column) ) then
       if ( column > get_num_of_columns(table) ) then
          ! raise an error?
       else
          the_column = column
       end if
    else
       the_column = 1   ! a default value, de facto
    end if

    reversing = .false.  ! default value
    if ( present(reverse) ) reversing = reverse

    do
       ! loops over the rows to sort... at some point, we need
       ! comparing an element (cell) of the row, with the element
       ! in another row; ... let us suppose rowA and rowB are
       ! the two rows we are considering
       ea = get_element(rowA, the_column)
       eb = get_element(rowB, the_column)
       if ( present(ordering) ) then
          if ( .not. reversing ) then
             if ( ordering(ea, eb) > 0 ) then
                ! swap the rowA with the rowB
             end if
          else   ! < instead of >
             if ( ordering(ea, eb) < 0 ) then
                ! swap the rowA with the rowB
             end if
          end if
       else
          if ( .not. reversing ) then
             if ( lexinternal(ea, eb) > 0 ) then
                ! swap the rowA with the rowB
             end if
          else   ! < instead of >
             if ( lexinternal(ea, eb) < 0 ) then
                ! swap the rowA with the rowB
             end if
          end if
       end if
       ! ... more of the sorting algo ...
       ! ... and rows traversing ... (and an exit condition of course!)
    end do

  end subroutine sort_table

end module ExampleOptionalParameter
