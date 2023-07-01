program main
implicit none
   call  compare('testing123testingthing', 'thisis',                 'thi')
   call  compare('testing',                'sting',                  'sting')
   call  compare('thisisatest_stinger',    'testing123testingthing', 'sting')
   call  compare('thisisatest_stinger',    'thisis',                 'thisis')
   call  compare('thisisatest',            'testing123testing',      'test')
   call  compare('thisisatest',            'thisisatest',            'thisisatest')
contains
subroutine compare(a,b,answer)
character(len=*),intent(in) :: a, b, answer
character(len=:),allocatable :: a2, match
character(len=*),parameter :: g='(*(g0))'
integer :: i
   a2=a ! should really make a2 the shortest and b the longest
   match=''
   do i=1,len(a2)-1
      call compare_sub(a2,b,match)
      if(len(a2).lt.len(match))exit
      a2=a2(:len(a2)-1)
   enddo
   write(*,g) merge('(PASSED)','(FAILED)',answer.eq.match), &
   & ' longest match found: "',match,'"; expected "',answer,'"', &
   & ' comparing "',a,'" and "',b,'"'
end subroutine
subroutine compare_sub(a,b,match)
character(len=*),intent(in) :: a, b
character(len=:),allocatable :: match
integer :: left, foundat, len_a
   len_a=len(a)
   do left=1,len_a
      foundat=index(b,a(left:))
      if(foundat.ne.0.and.len(match).lt.len_a-left+1)then
         if(len(a(left:)).gt.len(match))then
            match=a(left:)
            exit
         endif
      endif
   enddo
end subroutine compare_sub
end program main
