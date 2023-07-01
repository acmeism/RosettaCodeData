function getNextInput() result(Input)
    implicit none
    integer :: Input
    integer :: Reason
    Reason = 1

    do while (Reason > 0)
        print *, "Enter rainfall int, 99999 to quit: "
        read (*,*,IOSTAT=Reason) Input

        if (Reason > 0) then
            print *, "Invalid input"
        end if
    enddo

end function getNextInput

program recurringrainfall
    implicit none
    real        :: currentAverage
    integer     :: currentCount
    integer     :: lastInput
    integer     :: getNextInput

    currentAverage = 0
    currentCount = 0

    do
        lastInput = getNextInput()

        if (lastInput == 99999) exit

        currentCount = currentCount + 1
        currentAverage = currentAverage + (1/real(currentCount))*lastInput - (1/real(currentCount))*currentAverage

        print *, 'New Average: ', currentAverage
    enddo


end program recurringrainfall
