    integer function lcm(a,b)
    integer:: a,b
        lcm = a*b / gcd(a,b)
    end function lcm

    integer function gcd(a,b)
    integer :: a,b,t
        do while (b/=0)
            t = b
            b = mod(a,b)
            a = t
        end do
        gcd = abs(a)
    end function gcd
