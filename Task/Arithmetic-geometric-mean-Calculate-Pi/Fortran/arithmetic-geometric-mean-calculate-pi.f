program CalcPi
    ! Use real128 numbers: (append '_rf')
    use iso_fortran_env, only: rf => real128
    implicit none
    real(rf) :: a,g,s,old_pi,new_pi
    real(rf) :: a1,g1,s1
    integer :: k,k1,i

    old_pi = 0.0_rf;
    a = 1.0_rf; g = 1.0_rf/sqrt(2.0_rf); s = 0.0_rf; k = 0

    do i=1,100
        call approx_pi_step(a,g,s,k,a1,g1,s1,k1)
        new_pi = 4.0_rf * (a1**2.0_rf) / (1.0_rf - s1)
        if (abs(new_pi - old_pi).lt.(2.0_rf*epsilon(new_pi))) then
            ! If the difference between the newly and previously
            ! calculated pi is negligible, stop the calculations
            exit
        end if
        write(*,*) 'Iteration:',k1,' Diff:',abs(new_pi - old_pi),' Pi:',new_pi
        old_pi = new_pi
        a = a1; g = g1; s = s1; k = k1
    end do

    contains

    subroutine approx_pi_step(x,y,z,n,a,g,s,k)
        real(rf), intent(in) :: x,y,z
        integer, intent(in) :: n
        real(rf), intent(out) :: a,g,s
        integer, intent(out) :: k

        a = 0.5_rf*(x+y)
        g = sqrt(x*y)
        k = n + 1
        s = z + (2.0_rf)**(real(k)+1.0_rf) * (a**(2.0_rf) - g**(2.0_rf))
    end subroutine
end program CalcPi
