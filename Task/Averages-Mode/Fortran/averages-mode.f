program mode_test
  use Qsort_Module only Qsort => sort
  implicit none

  integer, parameter    :: S = 10
  integer, dimension(S) :: a1 = (/ -1, 7, 7, 2, 2, 2, -1, 7, -3, -3 /)
  integer, dimension(S) :: a2 = (/  1, 1, 1, 1, 1, 0, 2, 2, 2, 2 /)
  integer, dimension(S) :: a3 = (/  0, 0, -1, -1, 9, 9, 3, 3, 7, 7 /)

  integer, dimension(S) :: o
  integer               :: l, trash

  print *, stat_mode(a1)

  trash = stat_mode(a1, o, l)
  print *, o(1:l)
  trash = stat_mode(a2, o, l)
  print *, o(1:l)
  trash = stat_mode(a3, o, l)
  print *, o(1:l)

contains

  ! stat_mode returns the lowest (if not unique) mode
  ! others can hold other modes, if the mode is not unique
  ! if others is provided, otherslen should be provided too, and
  ! it says how many other modes are there.
  ! ok can be used to know if the return value has a meaning
  ! or the mode can't be found (void arrays)
  integer function stat_mode(a, others, otherslen, ok)
    integer, dimension(:), intent(in) :: a
    logical, optional, intent(out)    :: ok
    integer, dimension(size(a,1)), optional, intent(out) :: others
    integer, optional, intent(out)    :: otherslen

    ! ta is a copy of a, we sort ta modifying it, freq
    ! holds the frequencies and idx the index (for ta) so that
    ! the value appearing freq(i)-time is ta(idx(i))
    integer, dimension(size(a, 1)) :: ta, freq, idx
    integer                        :: rs, i, tm, ml, tf

    if ( present(ok) ) ok = .false.

    select case ( size(a, 1) )
    case (0)  ! no mode... ok is false
       return
    case (1)
       if ( present(ok) ) ok = .true.
       stat_mode = a(1)
       return
    case default
       if ( present(ok) ) ok = .true.
       ta = a         ! copy the array
       call sort(ta)  ! sort it in place (cfr. sort algos on RC)
       freq = 1
       idx = 0
       rs = 1         ! rs will be the number of different values

       do i = 2, size(ta, 1)
          if ( ta(i-1) == ta(i) ) then
             freq(rs) = freq(rs) + 1
          else
             idx(rs) = i-1
             rs = rs + 1
          end if
       end do
       idx(rs) = i-1

       ml = maxloc(freq(1:rs), 1)  ! index of the max value of freq
       tf = freq(ml)               ! the max frequency
       tm = ta(idx(ml))            ! the value with that freq

       ! if we want all the possible modes, we provide others
       if ( present(others) ) then
          i = 1
          others(1) = tm
          do
             freq(ml) = 0
             ml = maxloc(freq(1:rs), 1)
             if ( tf == freq(ml) ) then ! the same freq
                i = i + 1               ! as the max one
                others(i) = ta(idx(ml))
             else
                exit
             end if
          end do

          if ( present(otherslen) ) then
             otherslen = i
          end if

       end if
       stat_mode = tm
    end select

  end function stat_mode

end program mode_test
