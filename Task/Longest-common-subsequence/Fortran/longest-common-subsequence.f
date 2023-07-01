program lcstest
  use iso_varying_string
  implicit none

  type(varying_string) :: s1, s2

  s1 = "thisisatest"
  s2 = "testing123testing"
  print *, char(lcs(s1, s2))

  s1 = "1234"
  s2 = "1224533324"
  print *, char(lcs(s1, s2))

contains

  recursive function lcs(a, b) result(l)
    type(varying_string) :: l
    type(varying_string), intent(in) :: a, b

    type(varying_string) :: x, y

    l = ""
    if ( (len(a) == 0) .or. (len(b) == 0) ) return
    if ( extract(a, len(a), len(a)) == extract(b, len(b), len(b)) ) then
       l = lcs(extract(a, 1, len(a)-1), extract(b, 1, len(b)-1)) // extract(a, len(a), len(a))
    else
       x = lcs(a, extract(b, 1, len(b)-1))
       y = lcs(extract(a, 1, len(a)-1), b)
       if ( len(x) > len(y) ) then
          l = x
       else
          l = y
       end if
    end if
  end function lcs

end program lcstest
