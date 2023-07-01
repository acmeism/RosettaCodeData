function ffun(x, y)
    implicit none
    !DEC$ ATTRIBUTES DLLEXPORT, STDCALL, REFERENCE :: ffun
    double precision :: x, y, ffun
    ffun = x + y * y
end function
