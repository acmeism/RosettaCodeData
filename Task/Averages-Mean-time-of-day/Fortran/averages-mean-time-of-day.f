program mean_time_of_day
  implicit none
  integer(kind=4), parameter :: dp = kind(0.0d0)

  type time_t
    integer(kind=4) :: hours, minutes, seconds
  end type

  character(len=8), dimension(4), parameter :: times = &
    (/ '23:00:17', '23:40:20', '00:12:45', '00:17:19' /)
  real(kind=dp), dimension(size(times)) :: angles
  real(kind=dp) :: mean

  angles = time_to_angle(str_to_time(times))
  mean = mean_angle(angles)
  if (mean < 0) mean = 360 + mean

  write(*, fmt='(I2.2, '':'', I2.2, '':'', I2.2)') angle_to_time(mean)
contains
  real(kind=dp) function mean_angle(angles)
    real(kind=dp), dimension(:), intent (in) :: angles
    real(kind=dp) :: x, y

    x = sum(sin(radians(angles)))/size(angles)
    y = sum(cos(radians(angles)))/size(angles)

    mean_angle = degrees(atan2(x, y))
  end function

  elemental real(kind=dp) function radians(angle)
    real(kind=dp), intent (in) :: angle
    real(kind=dp), parameter :: pi = 4d0*atan(1d0)
    radians = angle/180*pi
  end function

  elemental real(kind=dp) function degrees(angle)
    real(kind=dp), intent (in) :: angle
    real(kind=dp), parameter :: pi = 4d0*atan(1d0)
    degrees = 180*angle/pi
  end function

  elemental type(time_t) function str_to_time(str)
    character(len=*), intent (in) :: str
    ! Assuming time in format hh:mm:ss
    read(str, fmt='(I2, 1X, I2, 1X, I2)') str_to_time
  end function

  elemental real(kind=dp) function time_to_angle(time) result (res)
    type(time_t), intent (in) :: time

    real(kind=dp) :: seconds
    real(kind=dp), parameter :: seconds_in_day = 24*60*60

    seconds = time%seconds + 60*time%minutes + 60*60*time%hours
    res = 360*seconds/seconds_in_day
  end function

  elemental type(time_t) function angle_to_time(angle)
    real(kind=dp), intent (in) :: angle

    real(kind=dp) :: seconds
    real(kind=dp), parameter :: seconds_in_day = 24*60*60

    seconds = seconds_in_day*angle/360d0
    angle_to_time%hours = int(seconds/60d0/60d0)
    seconds = mod(seconds, 60d0*60d0)
    angle_to_time%minutes = int(seconds/60d0)
    angle_to_time%seconds = mod(seconds, 60d0)
  end function
end program
