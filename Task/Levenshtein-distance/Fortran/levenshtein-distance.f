program demo_edit_distance
character(len=:),allocatable :: sources(:),targets(:)
integer,allocatable          :: answers(:),expected(:)

sources=[character(len=20)   :: "kitten",  "rosettacode",   "Saturday", "sleep",    "qwerty", "Fortran" ]
targets=[character(len=20)   :: "sitting", "raisethysword", "Sunday",   "fleeting", "qweryt", "Fortran" ]
expected=[                       3,         8,               3,          5,          2,        0        ]
! calculate answers
answers=edit_distance(sources,targets)
! print inputs, answers, and confirmation
do i=1, size(sources)
   write(*,'(*(g0,1x))') sources(i), targets(i), answers(i), answers(i) == expected(i)
enddo
! a longer test
write(*,*)edit_distance("here's a bunch of words", "to wring out this code")==18

contains

pure elemental integer function edit_distance (source,target)
!! The Levenshtein distance function returns how many edits (deletions,
!! insertions, transposition) are required to turn one string into another.
character(len=*), intent(in) :: source, target
integer                      :: len_source, len_target, i, j, cost
integer                      :: matrix(0:len_trim(source), 0:len_trim(target))
   len_source = len_trim(source)
   len_target = len_trim(target)
   matrix(:,0) = [(i,i=0,len_source)]
   matrix(0,:) = [(j,j=0,len_target)]
   do i = 1, len_source
      do j = 1, len_target
         cost=merge(0,1,source(i:i)==target(j:j))
         matrix(i,j) = min(matrix(i-1,j)+1, matrix(i,j-1)+1, matrix(i-1,j-1)+cost)
      enddo
   enddo
   edit_distance = matrix(len_source,len_target)
end function edit_distance

end program demo_edit_distance
