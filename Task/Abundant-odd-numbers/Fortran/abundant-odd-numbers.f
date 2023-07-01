program main
use,intrinsic :: iso_fortran_env, only : int8, int16, int32, int64
implicit none
integer,parameter          :: dp=kind(0.0d0)
character(len=*),parameter :: g='(*(g0,1x))'
integer                    :: j, icount
integer,allocatable        :: list(:)
real(kind=dp)              :: tally

   write(*,*)'N sum'
   icount=0                       ! number of abundant odd numbers found
   do j=1,huge(0)-1,2             ! loop through odd numbers for candidates
      list=divisors(j)            ! git list of divisors for current value
      tally= sum([real(list,kind=dp)]) ! sum divisors
      if(tally>2*j .and. iand(j,1) /= 0) then ! count an abundant odd number
         icount=icount+1
         select case(icount)  ! if one of the values targeted print it
         case(1:25,1000);write(*,g)icount,':',j!, list
         end select
      endif
      if(icount.gt.1000)exit ! quit after last targeted value is found
   enddo

   do j=1000000001,huge(0),2
      list=divisors(j)
      tally= sum([real(list,kind=dp)])
      if(tally>2*j .and. iand(j,1) /= 0) then
         write(*,g)'First abundant odd number greater than one billion:',j

         exit
      endif
   enddo

contains

function divisors(num) result (numbers)
!> brute force divisors
integer,intent(in) :: num
integer :: i
integer,allocatable :: numbers(:)
   numbers=[integer :: ]
   do i=1 , int(sqrt(real(num)))
      if (mod(num , i)  .eq. 0) numbers=[numbers, i,num/i]
   enddo
end function divisors

end program main
