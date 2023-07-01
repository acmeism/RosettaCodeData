program Median_Test

  real            :: a(7) = (/ 4.1, 5.6, 7.2, 1.7, 9.3, 4.4, 3.2 /), &
                     b(6) = (/ 4.1, 7.2, 1.7, 9.3, 4.4, 3.2 /)

  print *, median(a)
  print *, median(b)

contains

  function median(a, found)
    real, dimension(:), intent(in) :: a
      ! the optional found argument can be used to check
      ! if the function returned a valid value; we need this
      ! just if we suspect our "vector" can be "empty"
    logical, optional, intent(out) :: found
    real :: median

    integer :: l
    real, dimension(size(a,1)) :: ac

    if ( size(a,1) < 1 ) then
       if ( present(found) ) found = .false.
    else
       ac = a
       ! this is not an intrinsic: peek a sort algo from
       ! Category:Sorting, fixing it to work with real if
       ! it uses integer instead.
       call sort(ac)

       l = size(a,1)
       if ( mod(l, 2) == 0 ) then
          median = (ac(l/2+1) + ac(l/2))/2.0
       else
          median = ac(l/2+1)
       end if

       if ( present(found) ) found = .true.
    end if

  end function median

end program Median_Test
