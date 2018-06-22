i = 1
do
  write(*, '(I0)', advance='no') i
  if ( i == 10 ) exit
  write(*, '(A)', advance='no') ', '
  i = i + 1
end do
write(*,*)
