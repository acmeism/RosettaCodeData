program prog

    dimension a(100, 100)

    n = 7
	
    j1 = 1
    j2 = n
    do i = 1, n
        do j = 1, n
            a(i, j) = 0.
        end do
        a(i, j1) = 1
        a(i, j2) = 1
        j1 = j1 + 1
        j2 = j2 - 1
    end do

    do i = 1, n
        print *, (a(i, j), j=1,n)
    end do

end
