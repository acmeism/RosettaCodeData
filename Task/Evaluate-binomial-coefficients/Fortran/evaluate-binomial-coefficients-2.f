program binomial
    integer :: i, j

    do j=1,20
        write(*,fmt='(i2,a)',advance='no') j,'Cr = '
        do i=0,j
            write(*,fmt='(i0,a)',advance='no') n_C_r(j,i),' '
        end do
        write(*,'(a,i0)') ' 60C30 = ',n_C_r(60,30)
    end do
    stop

contains

    pure function n_C_r(n, r) result(bin)
        integer(16)         :: bin
        integer, intent(in) :: n
        integer, intent(in) :: r

        integer(16)         :: num
        integer(16)         :: den
        integer             :: i
        integer             :: k
        integer, parameter  :: primes(*) = [2,3,5,7,11,13,17,19]
        num = 1
        den = 1
        do i=0,r-1
            num = num*(n-i)
            den = den*(i+1)
            if (i > 0) then
                ! Divide out common prime factors
                do k=1,size(primes)
                    if (mod(i,primes(k)) == 0) then
                        num = num/primes(k)
                        den = den/primes(k)
                    end if
                end do
            end if
        end do
        bin = num/den
    end function n_C_r

end program binomial
