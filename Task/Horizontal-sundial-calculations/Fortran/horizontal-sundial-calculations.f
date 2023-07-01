program SunDial

  real    :: lat, slat, lng, ref
  real    :: hra, hla
  integer :: h

  real, parameter :: pi = 3.14159265358979323846

  print *, "Enter latitude"
  read *, lat
  print *, "Enter longitude"
  read *, lng
  print *, "Enter legal meridian"
  read *, ref

  print *

  slat = sin(dr(lat))
  write(*, '(A,1F6.3)') "sine of latitude: ", slat
  write(*, '(A,1F6.3)') "diff longitude: ", lng - ref

  print *, "Hour, sun hour angle, dial hour line angle from 6am to 6pm"

  do h = -6, 6
     hra = 15.0*h
     hra = hra - lng + ref
     hla = rd( atan( slat * tan( dr(hra) ) ) )
     write(*, '(" HR= ",I3,";  \t  HRA=",F7.3,";  \t  HLA= ", F7.3)'), h, hra, hla
  end do

contains

  function dr(angle)
    real :: dr
    real, intent(in) :: angle
    dr = angle*pi/180.0
  end function dr

  function rd(angle)
    real :: rd
    real, intent(in) :: angle
    rd = angle*180.0/pi
  end function rd

end program SunDial
