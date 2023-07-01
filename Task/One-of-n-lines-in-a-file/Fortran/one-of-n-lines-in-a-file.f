!> read lines one at a time and randomly choose one
!! using a Reservoir Sampling algorithm:
!! http://www.rosettacode.org/wiki/One_of_n_lines_in_a_file
program reservoir_sample
use, intrinsic :: iso_fortran_env, only : dp=>real64
implicit none
character(len=256)   :: line
integer              :: lun, n, i, count(10)
   call random_seed()
   !! create test file
   open(file='_data.txt',newunit=lun)
   do i=1,10
      write(lun,'(*(g0))')'test line ',i
   enddo
   !! run once and show result
   call one_of_n(line,n)
   write(*,'(i10,":",a)')n,trim(line)
   !! run 1 000 000, times on ten-line test file
   count=0
   do i=1,1000000
      call one_of_n(line,n)
      if(n.gt.0.and.n.le.10)then
         count(n)=count(n)+1
      else
         write(*,*)'<ERROR>'
      endif
   enddo
   write(*,*)count
   write(*,*)count-100000
contains
subroutine one_of_n(line,n)
character(len=256),intent(out) :: line
integer,intent(out)            :: n
real(kind=dp)                  :: rand_val
integer                        :: ios, ilines
   line=''
   ios=0
   ilines=1
   n=0
   rewind(lun)
   do
      call random_number(rand_val)
      if( rand_val < 1.0d0/(ilines) )then
         read(lun,'(a)',iostat=ios)line
         if(ios/=0)exit
         n=ilines
      else
         read(lun,'(a)',iostat=ios)
         if(ios/=0)exit
      endif
      ilines=ilines+1
   enddo
end subroutine one_of_n
end program reservoir_sample
}
