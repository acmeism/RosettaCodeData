program isbn13
    implicit none

    character(len=14), dimension(4), parameter  :: isbns=["978-1734314502", "978-1734314509", "978-1788399081", "978-1788399083"]
    integer                                     :: i

    do i = 1, ubound(isbns, 1)
        if (check_isbn13(isbns(i))) then
            print*, isbns(i), " : ", "good"
        else
            print*, isbns(i), " : ", "bad"
        end if
    end do
contains
    pure function check_isbn13(isbn)
        character(len=*), intent(in)    :: isbn
        logical                         :: check_isbn13
        integer                         :: summ, counter, i, digit

        check_isbn13 = .false.
        counter = 0
        summ = 0

        do i = 1, len(isbn)
            if (isbn(i:i) == ' ' .or. isbn(i:i) == '-') cycle
            counter = counter + 1
            read(isbn(i:i), '(I1)') digit
            if (modulo(counter, 2) == 0) then
                summ = summ + 3*digit
            else
                summ = summ + digit
            end if
        end do
        if (counter == 13 .and. modulo(summ, 10) == 0) check_isbn13 = .true.
    end function check_isbn13
end program isbn13
