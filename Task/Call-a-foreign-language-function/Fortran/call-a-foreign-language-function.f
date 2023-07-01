module c_api
    use iso_c_binding
    implicit none

    interface
        function strdup(ptr) bind(C)
            import c_ptr
            type(c_ptr), value :: ptr
            type(c_ptr) :: strdup
        end function
    end interface

    interface
        subroutine free(ptr) bind(C)
            import c_ptr
            type(c_ptr), value :: ptr
        end subroutine
    end interface

    interface
        function puts(ptr) bind(C)
            import c_ptr, c_int
            type(c_ptr), value :: ptr
            integer(c_int) :: puts
        end function
    end interface
end module

program c_example
    use c_api
    implicit none

    character(20), target :: str = "Hello, World!" // c_null_char
    type(c_ptr) :: ptr
    integer(c_int) :: res

    ptr = strdup(c_loc(str))

    res = puts(c_loc(str))
    res = puts(ptr)

    print *, transfer(c_loc(str), 0_c_intptr_t), &
             transfer(ptr, 0_c_intptr_t)
    call free(ptr)
end program
