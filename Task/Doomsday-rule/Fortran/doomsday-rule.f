      program someday   ! Calculates the day that a week falls on
          use datestuff
          implicit none
!
! PARAMETER definitions
!
          integer , parameter :: numdates = 7
!
! Local variable declarations
!
          character(30) , dimension(numdates) , save :: date_string
          integer , dimension(numdates) , save :: day
          character(9) , dimension(numdates) , save :: days
          integer :: j
          integer :: k
          integer , dimension(numdates) , save :: month
          integer , dimension(numdates) , save :: year
!
          data days/'Monday   ' , 'Tuesday  ' , 'Wednesday' , 'Thursday ' ,     &
              &'Friday   ' , 'Saturday ' , 'Sunday   '/
          data month/01 , 03 , 12 , 12 , 05 , 02 , 04/
          data day/06 , 29 , 07 , 23 , 14 , 12 , 02/
          data year/1800 , 1875 , 1915 , 1970 , 2043 , 2077 , 2101/
          data date_string/'1800-01-06 (January 6, 1800)' ,                     &
              &'1875-03-29 (March 29, 1875)' , '1915-12-07 (December 7, 1915)' ,&
              &'1970-12-23 (December 23, 1970)' , '2043-05-14 (May 14, 2043)' , &
              &'2077-02-12 (February 12, 2077)' , '2101-04-02 (April 2, 2101)'/                                                !
!*Code

          print *
          do j = 1 , numdates
              k = get_the_day(day(j) , month(j) , year(j))
              print '(a, t31,1a1,1x,a)' , date_string(j) , ':' , days(k)
          end do
      end program someday
      module datestuff
          implicit none
          public :: get_the_day
          private :: get_anchor_day , gregorian_leap_year
!
          enum , bind(c) ! Use enums to get greater clarity in the code
              enumerator :: january = 1 , february , march , april , may ,      &
                       & june , july , august , september , october , november ,&
                       & december
          end enum
          enum , bind(c)
              enumerator :: sunday = 0 , monday , tuesday , wednesday ,         &
                       & thursday , friday , saturday
          end enum
      contains
!
          pure function gregorian_leap_year(year) result(answer)      ! Tests if the year is a leap year
!
! Function and Dummy argument declarations
!
              logical :: answer
              integer , intent(in) :: year
!
              answer = .false.                              ! Set default to not a leap year
              if( mod(year , 4)==0 )answer = .true.         ! Year divisible by 4 = leap year
              if( mod(year , 100)==0 )then
                  if( mod(year , 400)==0 )then               ! Year divisible by 400 = century year that is leap year
                      answer = .true.
                  else
                      answer = .false.                       ! Century years are not leap years
                  end if
              end if
          end function gregorian_leap_year
!
          pure function get_anchor_day(year) result(answer) ! Returns Anchor Days in doomsday calculation
!Note: The days start as Monday = 1, Tuesday =2, etc until Sunday = 7
!The Doomsday rule, Doomsday algorithm or Doomsday method is an algorithm of determination of the day of the week for a given date.
!It provides a perpetual calendar because the Gregorian calendar moves in cycles of 400 years.
!It takes advantage of each year having a certain day of the week upon which certain easy-to-remember dates,
!called the doomsdays, fall; for example, the last day of February, 4/4, 6/6, 8/8, 10/10, and 12/12 all occur
! on the same day of the week in any year. Applying the Doomsday algorithm involves three steps: Determination of the anchor day
! for the century, calculation of the anchor day for the year from the one for the century, and selection of the closest date
! out of those that always fall on the doomsday, e.g., 4/4 and 6/6, and count of the number of days (modulo 7) between that
! date and the date in question to arrive at the day of the week. The technique applies to both the Gregorian calendar and the
! Julian calendar, although their doomsdays are usually different days of the week.
!
! Function and Dummy argument declarations
!
              integer :: answer
              integer , intent(in) :: year
!
! Local variable declarations
!
              integer :: diffyear
              integer :: div12
              integer :: numyears
              integer :: temp1
!
! End of declarations
!*Code
              numyears = mod(year , 100)                ! Get number of years greater than century

              temp1 = year - numyears                   ! Turn into a century year
              temp1 = mod(temp1 , 400)                  ! Now mod 400 to get base year for anchor day
              select case(temp1)                        ! Select the base day
              case(0)
                  answer = tuesday
              case(100)
                  answer = sunday
              case(200)
                  answer = friday
              case(300)
                  answer = wednesday
              case default                              ! Anything else is an error
                  ERROR Stop 'Bad Anchor Day'                    ! Finish with error
              end select
    !
    !Calculate the doomsday of any given year
    !
              div12 = int(numyears/12)               ! Get number of times 12 goes into year
              temp1 = mod(numyears , 12)             ! Get the remainer
              diffyear = int(temp1/4)                ! Div 4 (magic algorithm)
              answer = diffyear + div12 + answer + temp1
              answer = mod(answer , 7)
          end function get_anchor_day          ! Note: The days start as Sunday = 0, Monday = 1, Tuesday =2, etc until Saturda
!
          pure function get_the_day(day , month , year) result(answer)
! Note: The days start as Sunday = 0, Monday = 1, Tuesday =2, etc until Saturday = 6
!
! Function and Dummy argument declarations
              integer :: answer
              integer , intent(in) :: day
              integer , intent(in) :: month
              integer , intent(in) :: year
!
! Local variable declarations
              integer :: closest
              integer :: doomsday
              integer :: temp1
              integer :: temp2
              integer :: up_or_down
!
! End of declarations
!
    ! There are doomsdays in every month, so we know what month it is ...
    ! We need to find the doomsday in the relevant month
              select case(month)                                ! Scratch Variables
              case(january)
                  closest = merge(4,3,gregorian_leap_year(year))  ! Use merge as a ternary
              case(february)
                  closest = merge(29,28,gregorian_leap_year(year))  ! Use merge as a ternary
              case(march)
                  closest = 7
              case(april)
                  closest = 4
              case(may)
                  closest = 9
              case(june)
                  closest = 6
              case(july)
                  temp1 = abs(4 - day)
                  temp2 = abs(11 - day)
                  closest = merge(4,11,temp1<temp2)  ! Use merge as a ternary
              case(august)
                  closest = 8
              case(september)
                  closest = 5
              case(october)
                  temp1 = abs(10 - day)
                  temp2 = abs(31 - day)
                  closest = merge(10,31,temp1<temp2)  ! Use merge as a ternary
              case(november)
                  closest = 7
              case(december)
                  closest = 12
              case default
                  ERROR Stop 'Error in get the day'                   ! Stop on error
              end select
     !
     ! Ok now we get the doomsday in question - i.e. Monday, Tuesday for this year
              doomsday = get_anchor_day(year)           ! Get this years doomsday
    ! If closest day is less we need to count down, if it is bigger we count up

              if( closest>day )then
                  up_or_down = -7
              else if( closest<day )then
                  up_or_down = 7
              else
                  up_or_down = 0                    ! The days are equal. Set to zero so no counting needed
              end if
              temp1 = closest                       ! Set temp var to closest doomsday
              if( up_or_down>0 )then
                  do while ( temp1<=day )
                      temp2 = temp1
                      temp1 = temp1 + up_or_down    ! Count in sevens to the final
                  end do
                  temp1 = day - temp2
                  temp1 = (doomsday + 7) + temp1
              else if( up_or_down<0 )then
                  do while ( temp1>=day )
                      temp2 = temp1
                      temp1 = temp1 + up_or_down    ! Count in sevens to the final
                  end do
                  temp1 = temp2 - day               ! See how far away I am from this day
                  temp1 = (doomsday + 7) - temp1    ! Subtract the difference in days from the known doomsday
              else
                  temp1 = doomsday                  ! It fell on the doomsday
              end if
              answer = mod(temp1 , 7)               ! Turn Sundays into Zeros
          end function get_the_day
!
      end module datestuff
    !
