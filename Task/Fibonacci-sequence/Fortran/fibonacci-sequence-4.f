    function fibI(n)
        integer, intent(in) :: n
        integer, parameter :: fib0 = 0, fib1 = 1
        integer            :: fibI, back1, back2, i

        select case (n)
            case (:0);      fibI = fib0
            case (1);       fibI = fib1

            case default
                fibI = fib1
                back1 = fib0
                do i = 2, n
                    back2 = back1
                    back1 = fibI
                    fibI   = back1 + back2
                end do
         end select
    end function fibI
end module fibonacci
