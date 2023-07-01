program demo_sort_indexed
implicit none

   call print_sorted_by_length( [character(len=20) :: "shorter","longer"] )
   call print_sorted_by_length( [character(len=20) :: "abcd","123456789","abcdef","1234567"] )
   call print_sorted_by_length( [character(len=20) :: 'the','quick','brown','fox','jumps','over','the','lazy','dog'])

contains

subroutine print_sorted_by_length(list)
character(len=*) :: list(:)
integer :: i

   list(sort_int(len_trim(list)))=list ! sort by length from small to large
   write(*,'(i9,1x,a)')(len_trim(list(i)), list(i),i=size(list),1,-1)! print from last to first
   write(*,*)

end subroutine print_sorted_by_length

function sort_int(input) result(counts) ! **very** inefficient mini index sort
integer :: input(:), counts(size(input)), i
   counts=[(count(input(i) > input)+count(input(i) == input(:i)),i=1, size(input) )]
end function sort_int

end program demo_sort_indexed
