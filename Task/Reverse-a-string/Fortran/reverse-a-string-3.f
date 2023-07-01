 program reverse_string
  implicit none
  character (80) :: cadena
  integer :: k, n
  !
  cadena = "abcdefgh"
  n = len_trim (cadena)
  !
  write (*,*) cadena
  forall (k=1:n) cadena (k:k) = cadena (n-k+1:n-k+1)
  write (*,*) cadena
  !
end program reverse_string
