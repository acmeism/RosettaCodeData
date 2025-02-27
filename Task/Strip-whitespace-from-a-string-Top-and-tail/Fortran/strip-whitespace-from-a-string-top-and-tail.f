! Tested with GNU Fortran (GCC) 14.2.0
! Standard: Fortran 90+

program strip_demo
    implicit none
    character(21) :: str = "     Jabberwocky     "

    ! Show original string with delimiters
    write(*, '(A)') "Original:      '" // str // "'"

    ! Remove leading spaces (using adjustl)
    write(*, '(A)') "Remove left:   '" // adjustl(str) // "'"

    ! Remove trailing spaces (using trim)
    write(*, '(A)') "Remove right:  '" // trim(str) // "'"

    ! Remove both (using trim and adjustl)
    write(*, '(A)') "Remove both:   '" // trim(adjustl(str)) // "'"
end program strip_demo
</syntaxhighlight >

Output:
<pre>
Original:      '     Jabberwocky     '
Remove left:   'Jabberwocky          '
Remove right:  '     Jabberwocky'
Remove both:   'Jabberwocky'
</pre>
