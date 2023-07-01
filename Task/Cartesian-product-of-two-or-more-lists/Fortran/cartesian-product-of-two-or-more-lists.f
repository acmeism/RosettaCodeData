 ! Created by simon on 29/04/2021.

 ! ifort -o cartesian_product cartesian_product.f90 -check all

 module tuple
    implicit none
    private
    public :: tuple_t, operator(*), print

    type tuple_t(n)
        integer, len     :: n
        integer, private :: v(n)
    contains
        procedure, public :: print => print_tuple_t
        generic, public :: assignment(=) => eq_tuple_t
        procedure, public :: eq_tuple_t
    end type tuple_t

    interface print
        module procedure print_tuple_a_t
    end interface print
    interface operator(*)
        module procedure tup_times_tup
    end interface

 contains
    subroutine eq_tuple_t(this, src)
        class(tuple_t(*)), intent(inout) :: this
        integer, intent(in)              :: src(:)
        this%v = src
    end subroutine eq_tuple_t

    pure function tup_times_tup(a, b) result(r)
        type(tuple_t(*)), intent(in)  :: a
        type(tuple_t(*)), intent(in)  :: b
        type(tuple_t(2)), allocatable :: r(:)
        integer :: i, j, k

        allocate(r(a%n*b%n))
        k = 0
        do i=1,a%n
            do j=1,b%n
                k = k + 1
                r(k)%v = [a%v(i),b%v(j)]
            end do
        end do
    end function tup_times_tup

    subroutine print_tuple_t(this)
        class(tuple_t(*)), intent(in) :: this
        integer :: i
        write(*,fmt='(a)',advance='no') '{'
        do i=1,size(this%v)
            write(*,fmt='(i0)',advance='no') this%v(i)
            if (i < size(this%v)) write(*,fmt='(a)',advance='no') ','
        end do
        write(*,fmt='(a)',advance='no') '}'
    end subroutine print_tuple_t

    subroutine print_tuple_a_t(r)
        type(tuple_t(*)), intent(in) :: r(:)
        integer :: i
        write(*,fmt='(a)',advance='no') '{'
        do i=1,size(r)
            call r(i)%print
            if (i < size(r)) write(*,fmt='(a)',advance='no') ','
        end do
        write(*,fmt='(a)') '}'
    end subroutine print_tuple_a_t
 end module tuple

 program cartesian_product
    use tuple

    implicit none
    type(tuple_t(2)) :: a, b
    type(tuple_t(0)) :: z

    a = [1,2]
    b = [3,4]

    call print_product(a, b)
    call print_product(b, a)
    call print_product(z, a)
    call print_product(a, z)

    stop
 contains
    subroutine print_product(s, t)
        type(tuple_t(*)), intent(in) :: s
        type(tuple_t(*)), intent(in) :: t
        call s%print
        write(*,fmt='(a)',advance='no') ' x '
        call t%print
        write(*,fmt='(a)',advance='no') ' = '
        call print(s*t)
    end subroutine print_product
 end program cartesian_product
