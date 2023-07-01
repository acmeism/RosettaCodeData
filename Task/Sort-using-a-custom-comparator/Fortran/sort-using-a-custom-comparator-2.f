module comparators
  implicit none
contains
  integer function my_compare(a, b)
    character(len=*), intent(in) :: a, b

    character(len=max(len(a),len(b))) :: a1, b1

    a1 = a
    b1 = b
    call to_lower(b1)
    call to_lower(a1)

    if ( len(trim(a)) > len(trim(b)) ) then
       my_compare = -1
    elseif ( len(trim(a)) == len(trim(b)) ) then
       if ( a1 > b1 ) then
          my_compare = 1
       else
          my_compare = -1
       end if
    else
       my_compare = 1
    end if
  end function my_compare
end module comparators
