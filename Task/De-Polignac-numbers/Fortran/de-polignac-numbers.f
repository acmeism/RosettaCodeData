program Polignac
   ! (* De Polignac numbers *)
   implicit none

   integer, parameter :: MaxNumber = 500000  ! (* maximum number we will consider *)
   integer, parameter :: MaxPower = 20       ! (* maximum power of 2 < MaxNumber *)

   integer :: PowersOf2(1:MaxPower)
   logical :: Prime(0:MaxNumber)
   integer :: I, S, P, P2, DpCount, DoublI
   logical :: Found

   ! (* Sieve the primes to MaxNumber *)
   Prime(0) = .false.
   Prime(1) = .false.
   Prime(2) = .true.
   do I = 3, MaxNumber, 2
      Prime(I) = .true.
   end do
   do I = 4, MaxNumber, 2
      Prime(I) = .false.
   end do
   do I = 3, int(sqrt(real(MaxNumber))), 2
      if (Prime(I)) then
         S = I * I
         DoublI = I + I
         do while (S <= MaxNumber)
            Prime(S) = .false.
            S = S + DoublI
         end do
      end if
   end do

   ! (* Table of powers of 2 greater than 2^0 (up to around 2000000) Increase the table size if MaxNumber > 2000000 *)
   P2 = 1
   do I = 1, MaxPower
      P2 = P2 * 2
      PowersOf2(I) = P2
   end do

   ! (* The numbers must be odd and not of the form P + 2^N either P is odd and 2^N is even and hence N > 0 and P > 2 or 2^N is odd and P is even and hence N = 0 and P = 2 (the only even prime is 2, the only odd 2^N is 1). *)
   ! (* N = 0, P = 2 *)
   DpCount = 1
   write(*,'(I5)',advance='no') 1

   ! (* N > 0, P > 2 *)
   do I = 5, MaxNumber, 2
      Found = .false.
      P = 1
      do while ((P <= MaxPower) .and. (.not. Found) .and. (I > PowersOf2(P)))
         Found = Prime(I - PowersOf2(P))
         P = P + 1
      end do
      if (.not. Found) then
         DpCount = DpCount + 1
         if (DpCount <= 50) then
            write(*,'(I5)',advance='no') I
            if (mod(DpCount, 10) == 0) then
               write(*,*)
            end if
         else if ((DpCount == 1000) .or. (DpCount == 10000)) then
            write(*,'(A,I5,A,I7)') "The ", DpCount, "th de Polignac number is ", I
         end if
      end if
   end do
   write(*,'(A,I0,A,I0)') "Found ", DpCount, " de Polignac numbers up to ", MaxNumber

end program Polignac
