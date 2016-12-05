program chess960
    implicit none

    integer, pointer  :: a,b,c,d,e,f,g,h
    integer, target   :: p(8)
    a => p(1)
    b => p(2)
    c => p(3)
    d => p(4)
    e => p(5)
    f => p(6)
    g => p(7)
    h => p(8)

    king: do a=2,7                                        ! King on an internal square
        r1: do b=1,a-1                                    ! R1 left of the King
            r2: do c=a+1,8                                ! R2 right of the King
                b1: do d=1,7,2                            ! B1 on an odd square
                    if (skip_pos(d,4)) cycle
                    b2: do e=2,8,2                        ! B2 on an even square
                        if (skip_pos(e,5)) cycle
                        queen: do f=1,8                   ! Queen anywhere else
                            if (skip_pos(f,6)) cycle
                            n1: do g=1,7                  ! First knight
                                if (skip_pos(g,7)) cycle
                                n2: do h=g+1,8            ! Second knight (indistinguishable from first)
                                    if (skip_pos(h,8)) cycle
                                    if (sum(p) /= 36) stop 'Loop error'  ! Sanity check
                                    call write_position
                                end do n2
                            end do n1
                        end do queen
                    end do b2
                end do b1
            end do r2
        end do r1
    end do king

contains

    logical function skip_pos(i, n)
        integer, intent(in) :: i, n
        skip_pos = any(p(1:n-1) == i)
    end function skip_pos

    subroutine write_position
        integer           :: i, j
        character(len=15) :: position = ' '
        character(len=1), parameter  :: names(8) = ['K','R','R','B','B','Q','N','N']
        do i=1,8
            j = 2*p(i)-1
            position(j:j) = names(i)
        end do
        write(*,'(a)') position
    end subroutine write_position

end program chess960
