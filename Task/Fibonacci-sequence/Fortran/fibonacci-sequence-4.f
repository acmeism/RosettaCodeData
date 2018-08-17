module fibonacci
contains
    recursive function fibR(n) result(fib)
        integer, intent(in) :: n
        integer             :: fib

        select case (n)
            case (:0);      fib = 0
            case (1);       fib = 1
            case default;   fib = fibR(n-1) + fibR(n-2)
        end select
    end function fibR
