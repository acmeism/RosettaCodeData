program test
  implicit none
  integer :: i, j, n

  do i = 1, 5
    write(*, "(a, i0, a)", advance = "no") "Degree ", i, ": "
    do j = 1, 10
      n = multifactorial(j, i)
      write(*, "(i0, 1x)", advance = "no") n
    end do
    write(*,*)
  end do

contains

function multifactorial (range, degree)
  integer :: multifactorial, range, degree
  integer :: k

  multifactorial = product((/(k, k=range, 1, -degree)/))

end function multifactorial
end program test
