program recursion_depth

  implicit none

  call recurse (1)

contains

  recursive subroutine recurse (i)

    implicit none
    integer, intent (in) :: i

    write (*, '(i0)') i
    call recurse (i + 1)

  end subroutine recurse

end program recursion_depth
