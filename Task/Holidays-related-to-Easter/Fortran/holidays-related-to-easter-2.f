program christian_feasts
  implicit none
  integer :: year, i
  character(len=6), parameter :: NONE = '  --- '

  write(*,'(A)') 'CHRISTIAN FEAST DAYS'
  write(*,'(A)') repeat('=', 72)
  write(*,'(A)') 'Pre-Gregorian reform (400-1500 CE): Julian computus only'
  write(*,'(A)') 'Dates: DDMon(Julian) / DDMon(Gregorian proleptic)'
  write(*,'(A)') '(*) Trinity ~10th c.  (**) Corpus Christi from 1264 CE'
  write(*,'(A)') repeat('-', 72)
  write(*,'(A4,2X,A13,2X,A13,2X,A13,2X,A13,2X,A13)') &
    'Year', 'Easter       ', 'Ascension    ', 'Pentecost    ', &
    'Trinity*     ', 'CorpusChr**  '
  write(*,'(A)') repeat('-', 72)
  do i = 4, 15
    call pre_row(i * 100)
  end do

  write(*,*)
  write(*,'(A)') repeat('=', 72)
  write(*,'(A)') 'Post-Gregorian reform (1600-2100 CE + 2010-2020): Gregorian calendar'
  write(*,'(A)') 'Orthodox = Julian computus | Catholic = Gregorian computus'
  write(*,'(A)') 'Col 6: All Saints Sunday (+56) for Orthodox; Trinity Sunday (+56) for Catholic'
  write(*,'(A)') 'Col 7: Corpus Christi (+60) Catholic only'
  write(*,'(A)') repeat('-', 72)
  write(*,'(A4,2X,A8,2X,A6,2X,A6,2X,A6,2X,A6,2X,A6)') &
    'Year', 'Church  ', 'Easter', 'Ascensn', 'Pentecos', 'AS/Trin ', 'CorpChr '
  write(*,'(A)') repeat('-', 72)
  do i = 16, 21
    call post_rows(i * 100)
  end do
  write(*,'(A)') repeat('-', 72)
  write(*,'(A)') '  -- 2010 to 2020 --'
  write(*,'(A)') repeat('-', 72)
  do year = 2010, 2026
    call post_rows(year)
  end do

contains

  ! Julian computus: returns Easter month/day in Julian calendar
  subroutine julian_easter(yr, mo, dy)
    integer, intent(in)  :: yr
    integer, intent(out) :: mo, dy
    integer :: a, b, c, d, e
    a  = mod(yr, 4)
    b  = mod(yr, 7)
    c  = mod(yr, 19)
    d  = mod(19*c + 15, 30)
    e  = mod(2*a + 4*b - d + 34, 7)
    mo = (d + e + 114) / 31
    dy = mod(d + e + 114, 31) + 1
  end subroutine julian_easter

  ! Gregorian computus (Anonymous Gregorian algorithm): returns Easter in Gregorian calendar
  subroutine gregorian_easter(yr, mo, dy)
    integer, intent(in)  :: yr
    integer, intent(out) :: mo, dy
    integer :: a, b, c, d, e, f, g, h, ii, k, l, m
    a  = mod(yr, 19)
    b  = yr / 100
    c  = mod(yr, 100)
    d  = b / 4
    e  = mod(b, 4)
    f  = (b + 8) / 25
    g  = (b - f + 1) / 3
    h  = mod(19*a + b - d - g + 15, 30)
    ii = c / 4
    k  = mod(c, 4)
    l  = mod(32 + 2*e + 2*ii - h - k, 7)
    m  = (a + 11*h + 22*l) / 451
    mo = (h + l - 7*m + 114) / 31
    dy = mod(h + l - 7*m + 114, 31) + 1
  end subroutine gregorian_easter

  ! Julian calendar date -> Julian Day Number
  pure function jul2jdn(y, m, d) result(jdn)
    integer, intent(in) :: y, m, d
    integer :: jdn, a, yy, mm
    a  = (14 - m) / 12
    yy = y + 4800 - a
    mm = m + 12*a - 3
    jdn = d + (153*mm + 2)/5 + 365*yy + yy/4 - 32083
  end function jul2jdn

  ! Gregorian calendar date -> Julian Day Number
  pure function greg2jdn(y, m, d) result(jdn)
    integer, intent(in) :: y, m, d
    integer :: jdn, a, yy, mm
    a  = (14 - m) / 12
    yy = y + 4800 - a
    mm = m + 12*a - 3
    jdn = d + (153*mm + 2)/5 + 365*yy + yy/4 - yy/100 + yy/400 - 32045
  end function greg2jdn

  ! Julian Day Number -> Gregorian calendar date
  subroutine jdn2greg(jdn, y, m, d)
    integer, intent(in)  :: jdn
    integer, intent(out) :: y, m, d
    integer :: a, b, c, dd, e, mm
    a  = jdn + 32044
    b  = (4*a + 3) / 146097
    c  = a - (146097*b) / 4
    dd = (4*c + 3) / 1461
    e  = c - (1461*dd) / 4
    mm = (5*e + 2) / 153
    d  = e - (153*mm + 2)/5 + 1
    m  = mm + 3 - 12*(mm/10)
    y  = 100*b + dd - 4800 + mm/10
  end subroutine jdn2greg

  ! Julian Day Number -> Julian calendar date
  subroutine jdn2jul(jdn, y, m, d)
    integer, intent(in)  :: jdn
    integer, intent(out) :: y, m, d
    integer :: c, dd, e, mm
    c  = jdn + 32082
    dd = (4*c + 3) / 1461
    e  = c - (1461*dd) / 4
    mm = (5*e + 2) / 153
    d  = e - (153*mm + 2)/5 + 1
    m  = mm + 3 - 12*(mm/10)
    y  = dd - 4800 + mm/10
  end subroutine jdn2jul

  function mname(m) result(s)
    integer, intent(in) :: m
    character(len=3) :: s
    character(len=3), parameter :: names(12) = &
      ['Jan','Feb','Mar','Apr','May','Jun', &
       'Jul','Aug','Sep','Oct','Nov','Dec']
    s = names(m)
  end function mname

  ! Format JDN as "DDMon/DDMon" (Julian cal. / Gregorian proleptic), 13 chars
  function fmtjg(jdn) result(s)
    integer, intent(in) :: jdn
    character(len=13) :: s
    integer :: jy, jm, jd, gy, gm, gd
    call jdn2jul(jdn, jy, jm, jd)
    call jdn2greg(jdn, gy, gm, gd)
    write(s,'(I2.2,A3,A1,I2.2,A3)') jd, mname(jm), '/', gd, mname(gm)
  end function fmtjg

  ! Format JDN as "DD Mon" (Gregorian), 6 chars
  function fmtg(jdn) result(s)
    integer, intent(in) :: jdn
    character(len=6) :: s
    integer :: gy, gm, gd
    call jdn2greg(jdn, gy, gm, gd)
    write(s,'(I2.2,1X,A3)') gd, mname(gm)
  end function fmtg

  subroutine pre_row(year)
    integer, intent(in) :: year
    integer :: em, ed, jdn
    call julian_easter(year, em, ed)
    jdn = jul2jdn(year, em, ed)
    write(*,'(I4,2X,A13,2X,A13,2X,A13,2X,A13,2X,A13)') year, &
      fmtjg(jdn), fmtjg(jdn+39), fmtjg(jdn+49), &
      fmtjg(jdn+56), fmtjg(jdn+60)
  end subroutine pre_row

  subroutine post_rows(year)
    integer, intent(in) :: year
    integer :: em, ed, jdn_o, jdn_c
    ! Orthodox: Julian computus -> Julian calendar -> convert to Gregorian for display
    call julian_easter(year, em, ed)
    jdn_o = jul2jdn(year, em, ed)
    write(*,'(I4,2X,A8,2X,A6,2X,A6,2X,A6,2X,A6,2X,A6)') year, &
      'Orthodox', fmtg(jdn_o), fmtg(jdn_o+39), fmtg(jdn_o+49), &
      fmtg(jdn_o+56), NONE
    ! Catholic: Gregorian computus, already in Gregorian calendar
    call gregorian_easter(year, em, ed)
    jdn_c = greg2jdn(year, em, ed)
    write(*,'(4X,2X,A8,2X,A6,2X,A6,2X,A6,2X,A6,2X,A6)') &
      'Catholic', fmtg(jdn_c), fmtg(jdn_c+39), fmtg(jdn_c+49), &
      fmtg(jdn_c+56), fmtg(jdn_c+60)
    write(*,*)
  end subroutine post_rows

end program christian_feasts
