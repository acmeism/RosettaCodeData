      PROGRAM MAYA_DRIVER
      IMPLICIT NONE
!
! Local variables
!
      CHARACTER(80)  ::  haab_carry
      CHARACTER(80)  ::  long_carry
      CHARACTER(80)  ::  nightlord
      CHARACTER(80)  ::  tzolkin_carry
      INTEGER,DIMENSION(8) :: DAY, MONTH, YEAR
      INTEGER :: INDEX
      DATA YEAR /2071,2004,2012,2012,2019,2019,2020,2020/
      DATA MONTH /5,6,12,12,1,3,2,3/
      DATA DAY /16,19,18,21,19,27,29,01/
!  2071-05-16
!   2004-06-19
!   2012-12-18
!   2012-12-21
!   2019-01-19
!   2019-03-27
!   2020-02-29
!   2020-03-01
      DO INDEX = 1,8
!
          CALL MAYA_TIME(day(INDEX) , month(INDEX) , year(INDEX) , long_carry , haab_carry , tzolkin_carry ,       &
                       & nightlord)
          WRITE(6,20)day(INDEX),month(INDEX),year(INDEX),TRIM(tzolkin_carry),TRIM(haab_carry),TRIM(long_carry),TRIM(nightlord)
20    FORMAT(1X,I0,'-',I0,'-',I0,T12,A,T24,A,T38,A,T58,A)
      END DO
      STOP
      END PROGRAM MAYA_DRIVER
!
!   SUBROUTINE MAYA_TIME
    subroutine maya_time(day,month,year, long_carry,haab_carry, tzolkin_carry,nightlord)
    implicit none
    integer(kind=4), parameter :: startdate = 584283    ! Start of the Mayan Calendar in Julian days
    integer(kind=4), parameter :: kin = 1
    integer(kind=4), parameter :: winal = 20*kin
    integer(kind=4), parameter :: tun = winal*18
    integer(kind=4), parameter :: katun = tun*20
    integer(kind=4), parameter :: baktun = katun*20
    integer(kind=4), parameter :: piktun = baktun*20
    integer(kind=4), parameter :: longcount = baktun*20
!
    character(len=8), dimension(20) ,parameter :: tzolkin = &
                                             ["Imix'   ", "Ik´     ", "Ak´bal  ", "K´an    ", "Chikchan", "Kimi    ", &
                                              "Manik´  ", "Lamat   ", "Muluk   ", "Ok      ", "Chuwen  ", "Eb      ", &
                                              "Ben     ", "Hix     ", "Men     ", "K´ib´   ", "Kaban   ", "Etz´nab´", &
                                              "Kawak   ", "Ajaw    "]
    character(len=8), dimension(19) ,parameter :: haab = &
                                             ["Pop     ", "Wo´     ", "Sip     ", "Sotz´   ", "Sek     ", "Xul     ", &
                                              "Yaxk´in ", "Mol     ", "Ch´en   ", "Yax     ", "Sak´    ", "Keh     ", &
                                              "Mak     ", "K´ank´in", "Muwan   ", "Pax     ", "K´ayab  ", "Kumk´u  ", &
                                              "Wayeb´  "]
    character(len=20), dimension(9) ,parameter :: night_lords = &
                                             ["(G1) Xiuhtecuhtli   ", & ! ("Turquoise/Year/Fire Lord")
                                              "(G2) Tezcatlipoca   ", & ! ("Smoking Mirror")
                                              "(G3) Piltzintecuhtli", & ! ("Prince Lord")
                                              "(G4) Centeotl       ", & ! ("Maize God")
                                              "(G5) Mictlantecuhtli", & ! ("Underworld Lord")
                                              "(G6) Chalchiuhtlicue", & ! ("Jade Is Her Skirt")
                                              "(G7) Tlazolteotl    ", & ! ("Filth God[dess]")
                                              "(G8) Tepeyollotl    ", & ! ("Mountain Heart")
                                              "(G9) Tlaloc         "  ] ! (Rain God)
    integer(kind=4) :: day,month,year
    intent(in)      :: day,month,year
!
    integer(kind=4) :: j,l, numdays, keptdays
    integer(kind=4) :: kin_no, winal_no, tun_no, katun_no, baktun_no, longcount_no
    character(*) :: haab_carry, nightlord, tzolkin_carry, long_carry
    intent(inout) :: haab_carry, nightlord, tzolkin_carry, long_carry
    integer :: mo,da
!
    keptdays = julday(day,month,year)           ! Get the Julian date for selected date
    numdays = keptdays                          ! Keep for calcs later
!    Adjust from the beginning
    numdays = numdays-startdate                 ! Adjust the number of days from start of Mayan Calendar
    if (numdays .ge. longcount)then             ! We check if we have passed a longcount and need to adjust for a new start
        longcount_no = numdays/longcount
        print*, ' We have more than one longcount ',longcount_no
    endif
!
!   Calculate the longdate
    baktun_no = numdays/baktun
    numdays = numdays - (baktun_no*baktun)      ! Decrement days down by the number of baktuns
    katun_no = numdays/katun                    ! Get number of katuns
    numdays = numdays - (katun_no*katun)
    tun_no = numdays/tun
    numdays = numdays-(tun_no*tun)
    winal_no = numdays/winal
    numdays = numdays-(winal_no*winal)
    kin_no = numdays                                ! What is left is simply the days
    long_carry = ' '                                ! blank it out
    write(long_carry,'(4(i2.2,"."),I2.2)') baktun_no,katun_no,tun_no,winal_no,kin_no

!
!   OK. Now the longcount is done, let's calculate Tzolk´in, Haab´ & Nightlord (the calendar round)
!
    haab_carry = " "
    L = mod((keptdays+65),365)
    mo = (L/20)+1
    da = mod(l,20)
    if(da.ne.0)then
        write(haab_carry,'(i2,1x,a)') da,haab(mo)
    else
        write(haab_carry,'(a,1x,a)') 'Chum',haab(mo)
    endif
!
! Ok, Now let's calculate the Tzolk´in
! The calendar starts on the 4 Ahu
    tzolkin_carry = " "                     ! Total blank the carrier
    mo = mod((keptdays+16),20) + 1
    da = mod((keptdays+5),13) + 1
    write(tzolkin_carry,'(i2,1x,a)') da,tzolkin(mo)
!
!   Now let's have a look at the lords of the night
!   There are 9 lords of the night, let's assume that they start on the first day of the year
!
    numdays = keptdays -startdate           ! Elapsed Julian days since start of calendar
    J = mod(numdays,9)                      ! Number of days into this cycle
    if (j.eq.0) j = 9
    nightlord = night_lords(j)
    RETURN
    contains
!
    FUNCTION JULDAY( Id , Mm,  Iyyy)
      IMPLICIT NONE
!
! PARAMETER definitions
!
      INTEGER , PARAMETER  ::  IGREG = 15 + 31*(10 + 12*1582)
!
! Dummy arguments
!
      INTEGER  ::  Id , Iyyy , Mm
      INTEGER  ::  JULDAY
      INTENT (IN) Id , Iyyy , Mm
!
! Local variables
!
      INTEGER  ::  ja , jm , jy
!
      jy = Iyyy
      IF(jy == 0)STOP 'julday: there is no year zero'
      IF(jy < 0)jy = jy + 1
      IF(Mm > 2)THEN
         jm = Mm + 1
      ELSE
         jy = jy - 1
         jm = Mm + 13
      END IF
      JULDAY = 365*jy + INT(0.25D0*jy + 2000.D0) + INT(30.6001D0*jm) + Id + 1718995
      IF(Id + 31*(Mm + 12*Iyyy) >= IGREG)THEN
         ja = INT(0.01D0*jy)
         JULDAY = JULDAY + 2 - ja + INT(0.25D0*ja)
      END IF
      RETURN
          END FUNCTION JULDAY

    END SUBROUTINE maya_time
