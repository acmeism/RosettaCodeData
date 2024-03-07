program code_translation
    implicit none
    character(len=3), dimension(13) :: months = ["ERR", "Jan", "Feb", "Mar", "Apr", "May",&
    "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    type :: Date
        integer :: month, day
        logical :: active
    end type Date
    type(Date), dimension(10) :: dates = [Date(5,15,.true.), Date(5,16,.true.), Date(5,19,.true.), &
                                          Date(6,17,.true.), Date(6,18,.true.), &
                                          Date(7,14,.true.), Date(7,16,.true.), &
                                          Date(8,14,.true.), Date(8,15,.true.), Date(8,17,.true.)]
    integer, parameter :: UPPER_BOUND = size(dates)
write(*,*) 'possible dates: [[May 15] [May 16] [May 19] [June 17] [June 18] [July 14] [July 16] [August 14] [August 15] [August &
    17]]'
write(*,*)
write(*,*) '(1) Albert: I don''t know when Cheryl''s birthday is, but I know that Bernard does not know too.'
write(*,*) '	-> meaning: the month cannot have a unique day'
write(*,*) '	-> remaining: [[July 14] [July 16] [August 14] [August 15] [August 17]] '
write(*,*)
write(*,*) "(2) Bernard: At first I don't know when Cheryl's birthday is, but I know now."
write(*,*) '	-> meaning: the day must be unique'
write(*,*) '	-> remaining: [[July 16] [August 15] [August 17]] '
write(*,*)
write(*,*) '(3) Albert: Then I also know when Cheryl''s birthday is.'
write(*,*) '	-> meaning: the month must be unique'
write(*,*) '	-> remaining: [[July 16]] '

    call printRemaining()
    ! the month cannot have a unique day
    call firstPass()
    call printRemaining()
    ! the day must now be unique
    call secondPass()
    call printRemaining()
    ! the month must now be unique
    call thirdPass()
    call printAnswer()

contains

    subroutine printRemaining()
        integer :: i, c
        do i = 1, UPPER_BOUND
            if (dates(i)%active) then
                write(*,'(a,1x,i0,1x)',advance="no") months(dates(i)%month+1),dates(i)%day
                c = c + 1
            end if
        end do
!
        write(*,*)
    end subroutine printRemaining

    subroutine printAnswer()
        integer :: i
        write(*,'(a)',advance ='no') 'Cheryl''s birtday is on '
        do i = 1, UPPER_BOUND
            if (dates(i)%active) then
                write(*,'(a,1a1,i0)') trim(months(dates(i)%month+1)), ",", dates(i)%day
            end if
        end do
    end subroutine printAnswer

    subroutine firstPass()
        ! the month cannot have a unique day
        integer :: i, j, c
        do i = 1, UPPER_BOUND
            c = 0
            do j = 1, UPPER_BOUND
                if (dates(j)%day == dates(i)%day) then
                    c = c + 1
                end if
            end do
            if (c == 1) then
                do j = 1, UPPER_BOUND
                    if (.not. dates(j)%active) cycle
                    if (dates(j)%month == dates(i)%month) then
                        dates(j)%active = .false.
                    end if
                end do
            end if
        end do
    end subroutine firstPass

    subroutine secondPass()
        ! the day must now be unique
        integer :: i, j, c
        do i = 1, UPPER_BOUND
            if (.not. dates(i)%active) cycle
            c = 0
            do j = 1, UPPER_BOUND
                if (.not. dates(j)%active) cycle
                if (dates(j)%day == dates(i)%day) then
                    c = c + 1
                end if
            end do
            if (c > 1) then
                do j = 1, UPPER_BOUND
                    if (.not. dates(j)%active) cycle
                    if (dates(j)%day == dates(i)%day) then
                        dates(j)%active = .false.
                    end if
                end do
            end if
        end do
    end subroutine secondPass

    subroutine thirdPass()
        ! the month must now be unique
        integer :: i, j, c
        do i = 1, UPPER_BOUND
            if (.not. dates(i)%active) cycle
            c = 0
            do j = 1, UPPER_BOUND
                if (.not. dates(j)%active) cycle
                if (dates(j)%month == dates(i)%month) then
                    c = c + 1
                end if
            end do
            if (c > 1) then
                do j = 1, UPPER_BOUND
                    if (.not. dates(j)%active) cycle
                    if (dates(j)%month == dates(i)%month) then
                        dates(j)%active = .false.
                    end if
                end do
            end if
        end do
    end subroutine thirdPass

end program code_translation
