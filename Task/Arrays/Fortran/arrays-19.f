integer :: i
integer, dimension (10, 10) :: a = reshape ((/(i * i, i = 1, 100)/), (/10, 10/))
