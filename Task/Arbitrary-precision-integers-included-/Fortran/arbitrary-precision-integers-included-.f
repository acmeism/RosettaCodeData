program bignum
    use fmzm
    implicit none
    type(im) :: a
    integer :: n

    call fm_set(50)
    a = to_im(5)**(to_im(4)**(to_im(3)**to_im(2)))
    n = to_int(floor(log10(to_fm(a))))
    call im_print(a / to_im(10)**(n - 19))
    call im_print(mod(a, to_im(10)**20))
end program
