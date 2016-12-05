!================================================
        program pi_spigot_unbounded
!================================================
          do
            call print_next_pi_digit()
          end do

        contains

!------------------------------------------------
          subroutine print_next_pi_digit()
!------------------------------------------------
            use fmzm
            type (im) :: q, r, t, k, n, l, nr
            logical   :: dot=.false., init=.false.
            save      :: q, r, t, k, n, l
            if (.not.init) then
              q=to_im(1)
              r=to_im(0)
              t=to_im(1)
              k=to_im(1)
              n=to_im(3)
              l=to_im(3)
              init=.true.
            end if
            if (4*q+r-t < n*t) then
              write(6,fmt='(i1)',advance='no') to_int(n)
              if (.not.dot) then
                write(6,fmt='(a1)',advance='no') '.'
                dot=.true.
              end if
              flush(6)
              nr = 10 * (        r      - n*t )
              n  = 10 * ( (3*q + r) / t - n   )
              q  = 10 *      q
              r  = nr
            else
              nr = (2*q + r) * l
              n  = ( (q * (7*k + 2) + r*l) / (t*l) )
              q  = q * k
              t  = t * l
              l  = l + 2
              k  = k + 1
              r  = nr
            end if
          end subroutine

        end program
