  recursive function is_palindro_r (t) result (isp)

    implicit none
    character (*), intent (in) :: t
    logical :: isp

    isp = len (t) == 0 .or. t (: 1) == t (len (t) :) .and. is_palindro_r (t (2 : len (t) - 1))

  end function is_palindro_r
