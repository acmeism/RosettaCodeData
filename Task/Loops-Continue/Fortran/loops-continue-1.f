do i = 1, 10
   write(*, '(I0)', advance='no') i
   if ( mod(i, 5) == 0 ) then
      write(*,*)
      cycle
   end if
   write(*, '(A)', advance='no') ', '
end do
