program discordianDate
    implicit none
    ! Declare variables
    character(32) :: arg
    character(15) :: season,day,holyday
    character(80) :: Output,fmt1,fmt2,fmt3
    character(2) :: dayfix,f1,f2,f3,f4
    integer :: i,j,k,daysofyear,dayofweek,seasonnum,yold,dayofseason,t1,t2,t3
    integer,dimension(8) :: values
    integer, dimension(12) :: daysinmonth
    logical  :: isleapyear, isholyday, Pleapyear

    ! Get the current date
    call date_and_time(VALUES=values)
    ! Set some values up to defaults
    daysinmonth = (/ 31,28,31,30,31,30,31,31,30,31,30,31 /)
    isleapyear = .false.
    isholyday = .false.
    ! process any command line arguments
    ! using arguments dd mm yyyy
    j = iargc()
    do i = 1, iargc()
      call getarg(i, arg)  ! fetches argument as a character string
      if (j==3) then
        if (i==1) then
          read(arg,'(i2)') values(3)  ! convert to integer
        endif
        if (i==2) then
          read(arg,'(i2)') values(2)  ! convert to integer
        endif
        if (i==3) then
          read(arg,'(i4)') values(1)  ! convert to integer

        endif
      endif
      if (j==2) then  ! arguments dd mm
        if (i==1) then
          read(arg,'(i2)') values(3)  ! convert to integer
        endif
        if (i==2) then
          read(arg,'(i2)') values(2)  ! convert to integer
        endif
      endif
      if (j==1) then ! argument dd
        read(arg,'(i2)') values(3)  ! convert to integer
      endif
    end do

    !Start the number crunching here

    yold = values(1) + 1166
    daysofyear = 0
    if (values(2)>1) then
    do i=1 , values(2)-1 , 1
        daysofyear = daysofyear + daysinmonth(i)
     end do
   end if
    daysofyear = daysofyear + values(3)
    isholyday = .false.
    isleapyear = Pleapyear(yold)
    dayofweek = mod (daysofyear, 5)
    seasonnum = ((daysofyear - 1) / 73) + 1
    dayofseason = daysofyear - ((seasonnum - 1)  * 73)
    k = mod(dayofseason,10)  ! just to get the day number postfix
    select case (k)
      case (1)
         dayfix='st'
      case (2)
         dayfix='nd'
      case (3)
         dayfix='rd'
      case default
         dayfix='th'
    end select
    ! except between 10th and 20th  where we always have 'th'
    if (((dayofseason > 10) .and. (dayofseason < 20)) .eqv. .true.) then
      dayfix = 'th'
    end if
    select case (Seasonnum)
      case (1)
        season ='Choas'
        f4 = '5'
      case (2)
        season ='Discord'
        f4 = '7'
      case (3)
        season ='Confusion'
        f4 = '9'
      case (4)
        season ='Bureaucracy'
        f4 = '10'
      case (5)
        season ='The Aftermath'
        f4 = '13'
    end select
    select case (dayofweek)
       case (0)
         day='Setting Orange'
         f2 = '14'
       case (1)
         day ='Sweetmorn'
         f2 = '9'
       case (2)
         day = 'Boomtime'
         f2 = '8'
       case (3)
         day = 'Pungenday'
         f2 = '9'
       case (4)
         day = 'Prickle-Prickle'
         f2 = '15'
    end select
    ! check for holydays
    select case (dayofseason)
      case (5)
        isholyday = .true.
        select case (seasonnum)
          case (1)
             holyday ='Mungday'
             f1 = '7'
          case (2)
             holyday = 'Mojoday'
             f1 = '7'
          case (3)
            holyday = 'Syaday'
            f1 = '6'
          case (4)
             holyday = 'Zaraday'
             f1 = '7'
          case (5)
            holyday = 'Maladay'
            f1 = '7'
         end select
      Case (50)
        isholyday = .true.
        select case (seasonnum)
          case (1)
            holyday = 'Chaoflux'
            f1 = '8'
          case (2)
            holyday = 'Discoflux'
            f1 = '9'
          case (3)
            holyday = 'Confuflux'
            f1 = '9'
          case (4)
            holyday = 'Bureflux'
            f1 = '8'
          case (5)
            holyday = 'Afflux'
            f1 = '6'
         end select
    end select


    ! Check if it is St. Tibbs day
    if (isleapyear .eqv. .true.) then
      if ((values(2) == 2) .and. (values(3) == 29)) then
         isholyday = .true.
      end if
    end if
    ! Construct our format strings
    f3 = "2"
    if (dayofseason < 10) then
      f3 = "1"
    end if
    fmt1 = "(a,i4)"
    fmt2 = "(A,a" // f1 // ",A,A" // f2 // ",A,I" // f3 // ",A2,A,A" // f4 // ",A,I4)"
    fmt3 = "(A,A" // f2 // ",A,I" // f3 //",A2,A,A" // f4 // ",A,I4)"
    ! print an appropriate line
    if (isholyday .eqv. .true.) then
      if (values(3) == 29) then
         print fmt1,'Celebrate for today is St. Tibbs Day in the YOLD ',yold
       else
         print fmt2, 'Today is ',holyday, ' on ',day,' the ',dayofseason,dayfix,' day of ',season,' in the YOLD ',yold
       end if
     else   ! not a holyday
         print fmt3, 'Today is ',day,' the ',dayofseason,dayfix, ' day of ',season,' in the YOLD ',yold
     end if
    end program discordianDate

    ! Function to check to see if this is a leap year returns true or false!

    function Pleapyear(dloy) result(leaper)
    implicit none
    integer, intent(in) :: dloy
    logical :: leaper
    leaper = .false.
    if (mod((dloy-1166),4) == 0)  then
      leaper = .true.
    end if
    if (mod((dloy-1166),100) == 0) then
        leaper = .false.
        if (mod((dloy-1166),400)==0) then
           leaper = .true.
        end if
    end if
    end function Pleapyear
