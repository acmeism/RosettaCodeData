program resistor_mesh
    implicit none
    integer, parameter :: n = 10
    integer, parameter :: nn = n * n
    real(8) :: a(1:nn, 1:nn + 1)
    integer :: node, row, col
    integer :: ar, ac, anode, br, bc, bnode
    integer :: r, j, i
    real(8) :: y
    real(8) :: resistance

    a = 0.d0

    node = 0
    do row = 1, n
        do col = 1, n
            node = node + 1
            if (row > 1) then
                a(node, node) = a(node, node) + 1
                a(node, node - n) = -1
            end if
            if (row < n) then
                a(node, node) = a(node, node) + 1
                a(node, node + n) = -1
            end if
            if (col > 1) then
                a(node, node) = a(node, node) + 1
                a(node, node - 1) = -1
            end if
            if (col < n) then
                a(node, node) = a(node, node) + 1
                a(node, node + 1) = -1
            end if
        end do
    end do

    ! These are columns and rows in the matrix to calculate the position of A and B
    ! A is row 2 column 2
    ! B is row 7 column 8
    ar = 2
    ac = 2
    anode = ac + n * (ar - 1)
    br = 7
    bc = 8
    bnode = bc + n * (br - 1)
    a(anode, nn + 1) = -1
    a(bnode, nn + 1) = 1

    ! Solve linear system using Gauss-Jordan elimination
    r = nn
    do j = 1, r
        ! Find first non-zero pivot
        i = j
        do while (i <= r .and. a(i, j) == 0.d0)
            i = i + 1
        end do
        if (i > r) then
            print *, "No solution!"
            stop
        end if
        ! Swap rows j and i using array slicing
        a([j, i], 1:r+1) = a([i, j], 1:r+1)

        ! Scale pivot row using array operation
        y = 1.d0 / a(j, j)
        a(j, 1:r+1) = y * a(j, 1:r+1)

        ! Eliminate in other rows using array broadcasting
        do i = 1, r
            if (i /= j) then
                y = -a(i, j)
                a(i, 1:r+1) = a(i, 1:r+1) + y * a(j, 1:r+1)
            end if
        end do
    end do

    resistance = abs(a(anode, nn + 1) - a(bnode, nn + 1))

    print *
    write(*, '(A,I0,A,I0,A,F15.10,A)') "Resistance between Nodes ", anode, " and ", bnode, " is ", resistance, " Ohms"

end program resistor_mesh
