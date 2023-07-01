! RossetaCode: Sum to 100, Fortran 95, an algorithm using ternary numbers.
!
! Find solutions to the 'sum to one hundred' puzzle.
!
! We optimize algorithms for size. Therefore we don't use arrays, but recompute
! all values again and again. It is a little surprise that the time efficiency
! is quite acceptable. Actually the code is more compact than the implementation
! in C++ (STL maps and sets). We purposely break DRY and use magic values.
! Nevertheless, it is Fortran 95, free form lines, do-endo etc.

program sumto100

    parameter (nexpr = 13122)

    print *
    print *, 'Show all solutions that sum to 100'
    print *
    do i = 0, nexpr-1
        if ( ievaluate(i) .eq. 100 ) then
            call printexpr(i)
        endif
    enddo

    print *
    print *, 'Show the sum that has the maximum number of solutions'
    print *
    ibest = -1
    nbest = -1
    do i = 0, nexpr-1
        itest = ievaluate(i)
        if ( itest .ge. 0 ) then
            ntest = 0
            do j = 0, nexpr-1
                if ( ievaluate(j) .eq. itest ) then
                    ntest = ntest + 1
                endif
            enddo
            if ( (ntest .gt. nbest) ) then
                ibest = itest
                nbest = ntest
            endif
        endif
    enddo
    print *, ibest, ' has ', nbest, ' solutions'
    print *
!   do i = 0, nexpr-1
!       if ( ievaluate(i) .eq. ibest ) then
!           call printexpr(i)
!       endif
!   enddo

    print *
    print *, 'Show the lowest positive number that can''t be expressed'
    print *
    loop: do i = 0,123456789
        do j = 0,nexpr-1
            if ( i .eq. ievaluate(j) ) then
                cycle loop
            endif
        enddo
        exit
    enddo loop
    print *, i

    print *
    print *, 'Show the ten highest numbers that can be expressed'
    print *
    ilimit = 123456789
    do i = 1,10
        ibest = 0
        do j = 0, nexpr-1
            itest = ievaluate(j)
            if ( (itest .le. ilimit) .and. (itest .gt. ibest ) ) then
                ibest = itest
            endif
        enddo
        do j = 0, nexpr-1
            if ( ievaluate(j) .eq. ibest ) then
                call printexpr(j)
            endif
        enddo
        ilimit = ibest - 1;
    enddo

end

function ievaluate(icode)
    ic = icode
    ievaluate = 0
    n = 0
    ip = 1
    do k = 9,1,-1
        n = ip*k + n
        select case(mod(ic,3))
            case ( 0 )
                ievaluate = ievaluate + n
                n = 0
                ip = 1
            case ( 1 )
                ievaluate = ievaluate - n
                n = 0
                ip = 1
            case ( 2 )
                ip = ip * 10
        end select
        ic = ic / 3
    enddo
end

subroutine printexpr(icode)
    character(len=32) s
    ia = 19683
    ib =  6561
    s = ""
    do k = 1,9
        ic = mod(icode,ia) / ib
        ia = ib
        ib = ib / 3
        select case(mod(ic,3))
            case ( 0 )
                if ( k .gt. 1 ) then
                    s = trim(s) // '+'
                endif
            case ( 1 )
                s = trim(s) // '-'
        end select
        s = trim(s) // char(ichar('0')+k)
    end do
    ivalue = ievaluate(icode)
    print *, ivalue, ' = ', s
end
