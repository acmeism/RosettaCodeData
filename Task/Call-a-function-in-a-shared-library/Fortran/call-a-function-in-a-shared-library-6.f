function ffun(x, y)
    implicit none
    !GCC$ ATTRIBUTES DLLEXPORT, STDCALL :: FFUN
    double precision :: x, y, ffun
    ffun = x + y * y
end function
