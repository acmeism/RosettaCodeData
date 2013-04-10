program game_24
  implicit none
  real               :: vector(4), reals(11), result, a, b, c, d
  integer            :: numbers(4), ascii(11), i
  character(len=11)  :: expression
  character          :: syntax(11)
  ! patterns:
  character, parameter :: one(11)   = (/ '(','(','1','x','1',')','x','1',')','x','1' /)
  character, parameter :: two(11)   = (/ '(','1','x','(','1','x','1',')',')','x','1' /)
  character, parameter :: three(11) = (/ '1','x','(','(','1','x','1',')','x','1',')' /)
  character, parameter :: four(11)  = (/ '1','x','(','1','x','(','1','x','1',')',')' /)
  character, parameter :: five(11)  = (/ '(','1','x','1',')','x','(','1','x','1',')' /)

  do
    call random_number(vector)
    numbers = 9 * vector + 1
    write (*,*) 'Digits: ',numbers
    write (*,'(a)',advance='no') 'Your expression: '
    read (*,'(a11)') expression

    forall (i=1:11) syntax(i) = expression(i:i)
    ascii = iachar(syntax)
    where (syntax >= '0' .and. syntax <= '9')
      syntax = '1'  ! number
    elsewhere (syntax == '+' .or. syntax == '-' .or. syntax == '*' .or. syntax == '/')
      syntax = 'x'  ! op
    elsewhere (syntax /= '(' .and. syntax /= ')')
      syntax = '-'  ! error
    end where

    reals = real(ascii-48)
    if ( all(syntax == one) ) then
      a = reals(3); b = reals(5); c = reals(8); d = reals(11)
      call check_numbers(a,b,c,d)
      result = op(op(op(a,4,b),7,c),10,d)
    else if ( all(syntax == two) ) then
      a = reals(2); b = reals(5); c = reals(7); d = reals(11)
      call check_numbers(a,b,c,d)
      result = op(op(a,3,op(b,6,c)),10,d)
    else if ( all(syntax == three) ) then
      a = reals(1); b = reals(5); c = reals(7); d = reals(10)
      call check_numbers(a,b,c,d)
      result = op(a,2,op(op(b,6,c),9,d))
    else if ( all(syntax == four) ) then
      a = reals(1); b = reals(4); c = reals(7); d = reals(9)
      call check_numbers(a,b,c,d)
      result = op(a,2,op(b,5,op(c,8,d)))
    else if ( all(syntax == five) ) then
      a = reals(2); b = reals(4); c = reals(8); d = reals(10)
      call check_numbers(a,b,c,d)
      result = op(op(a,3,b),6,op(c,9,d))
    else
      stop 'Input string: incorrect syntax.'
    end if

    if ( abs(result-24.0) < epsilon(1.0) ) then
      write (*,*) 'You won!'
    else
      write (*,*) 'Your result (',result,') is incorrect!'
    end if

    write (*,'(a)',advance='no') 'Another one? [y/n] '
    read (*,'(a1)') expression
    if ( expression(1:1) == 'n' .or. expression(1:1) == 'N' ) then
      stop
    end if
  end do

contains

  pure real function op(x,c,y)
    integer, intent(in) :: c
    real, intent(in) :: x,y
    select case ( char(ascii(c)) )
      case ('+')
        op = x+y
      case ('-')
        op = x-y
      case ('*')
        op = x*y
      case ('/')
        op = x/y
    end select
  end function op

  subroutine check_numbers(a,b,c,d)
    real, intent(in) :: a,b,c,d
    integer          :: test(4)
    test = (/ nint(a),nint(b),nint(c),nint(d) /)
    call Insertion_Sort(numbers)
    call Insertion_Sort(test)
    if ( any(test /= numbers) ) then
      stop 'You cheat ;-) (Incorrect numbers)'
    end if
  end subroutine check_numbers

  pure subroutine Insertion_Sort(a)
    integer, intent(inout) :: a(:)
    integer                :: temp, i, j
    do i=2,size(a)
      j = i-1
      temp = a(i)
      do while ( j>=1 .and. a(j)>temp )
        a(j+1) = a(j)
        j = j - 1
      end do
      a(j+1) = temp
    end do
  end subroutine Insertion_Sort

end program game_24
