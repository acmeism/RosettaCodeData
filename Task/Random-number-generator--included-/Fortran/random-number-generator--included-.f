program rosetta_random
   implicit none

   integer, parameter :: rdp = kind(1.d0)
   real(rdp) :: num
   integer, allocatable :: seed(:)
   integer :: un,n, istat

   call random_seed(size = n)
   allocate(seed(n))

   ! Seed with the OS random number generator
   open(newunit=un, file="/dev/urandom", access="stream", &
   form="unformatted", action="read", status="old", iostat=istat)
   if (istat == 0) then
      read(un) seed
      close(un)
   end if
   call random_seed (put=seed)
   call random_number(num)
   write(*,'(E24.16)') num
end program rosetta_random
