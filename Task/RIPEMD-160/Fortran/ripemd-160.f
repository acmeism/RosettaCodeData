program main
    use, intrinsic :: iso_c_binding
    implicit none

    integer, parameter :: DIGEST_LEN = 20
    integer, parameter :: HASH_LEN   = 40

    interface
        function c_ripemd160(d, n, md) bind(c, name='RIPEMD160')
            import :: c_char, c_long, c_ptr
            implicit none
            character(kind=c_char), intent(in)        :: d
            integer(kind=c_long),   intent(in), value :: n
            character(kind=c_char), intent(in)        :: md
            type(c_ptr)                               :: c_ripemd160
        end function c_ripemd160
    end interface

    print '(a)', ripemd160('Rosetta Code')
contains
    function ripemd160(str) result(hash)
        character(len=*), intent(in) :: str
        character(len=HASH_LEN)      :: hash

        character(len=DIGEST_LEN) :: raw
        integer                   :: i
        type(c_ptr)               :: ptr

        hash = ' '
        ptr = c_ripemd160(str, len(str, kind=c_long), raw)
        if (.not. c_associated(ptr)) return
        write (hash, '(20z2.2)') (raw(i:i), i = 1, DIGEST_LEN)
    end function ripemd160
end program main
