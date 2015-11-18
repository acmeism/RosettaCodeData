program allperm
    implicit none
    integer :: n, i
    integer, allocatable :: a(:)
    read *, n
    allocate(a(n))
    a = [ (i, i = 1, n) ]
    call perm(1)
    deallocate(a)
contains
    recursive subroutine perm(i)
        integer :: i, j, t
        if (i == n) then
            print *, a
        else
            do j = i, n
                t = a(i)
                a(i) = a(j)
                a(j) = t
                call perm(i + 1)
                t = a(i)
                a(i) = a(j)
                a(j) = t
            end do
        end if
    end subroutine
end program
