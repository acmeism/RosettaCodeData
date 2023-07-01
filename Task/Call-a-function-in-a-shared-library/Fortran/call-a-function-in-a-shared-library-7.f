program dynload
    use kernel32
    use iso_c_binding
    implicit none

    abstract interface
        function ffun_int(x, y)
            !GCC$ ATTRIBUTES DLLEXPORT, STDCALL :: FFUN
            double precision :: ffun_int, x, y
        end function
    end interface

    procedure(ffun_int), pointer :: ffun_ptr

    integer(c_intptr_t) :: ptr
    integer(handle) :: h
    double precision :: x, y

    h = LoadLibrary("dllfun.dll" // c_null_char)
    if (h == 0) error stop "Error: LoadLibrary"

    ptr = GetProcAddress(h, "ffun_@8" // c_null_char)
    if (ptr == 0) error stop "Error: GetProcAddress"

    call c_f_procpointer(transfer(ptr, c_null_funptr), ffun_ptr)
    read *, x, y
    print *, ffun_ptr(x, y)

    if (FreeLibrary(h) == 0) error stop "Error: FreeLibrary"
end program
