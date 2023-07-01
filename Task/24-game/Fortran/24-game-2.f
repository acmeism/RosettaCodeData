! implement a recursive descent parser
module evaluate_algebraic_expression

  integer, parameter :: size = 124
  character, parameter :: statement_end = achar(0)
  character(len=size) :: text_to_parse
  integer :: position
  data position/0/,text_to_parse/' '/

contains

  character function get_token()
    ! return the current token
    implicit none
    if (position <= size) then
       get_token = text_to_parse(position:position)
       do while (get_token <= ' ')
          call advance
          if (size < position) exit
          get_token = text_to_parse(position:position)
       end do
    end if
    if (size < position) get_token = statement_end
  end function get_token

  subroutine advance ! consume a token.  Move to the next token.  consume_token would have been a better name.
    position = position + 1
  end subroutine advance

  logical function unfinished()
    unfinished = get_token() /= statement_end
  end function unfinished

  subroutine parse_error()
    write(6,*)'"'//get_token()//'" unexpected in expression at',position
    stop 1
  end subroutine parse_error

  function precedence3() result(a)
    implicit none
    real :: a
    character :: token
    character(len=10), parameter :: digits = '0123456789'
    token = get_token()
    if (verify(token,digits) /= 0) call parse_error()
    a = index(digits, token) - 1
    call advance()
  end function precedence3

  recursive function precedence2() result(a)
    real :: a
    character :: token
    token = get_token()
    if (token /= '(') then
       a = precedence3()
    else
       call advance
       a = precedence0()
       token = get_token()
       if (token /= ')') call parse_error()
       call advance
    end if
  end function precedence2

  recursive function precedence1() result(a)
    implicit none
    real :: a
    real, dimension(2) :: argument
    character(len=2), parameter :: tokens = '*/'
    character :: token
    a = 0
    token = get_token()
    argument(1) = precedence2()
    token = get_token()
    do while (verify(token,tokens) == 0)
       call advance()
       argument(2) = precedence2()
       if (token == '/') argument(2) = 1 / argument(2)
       argument(1) = product(argument)
       token = get_token()
    end do
    a = argument(1)
  end function precedence1

  recursive function precedence0() result(a)
    implicit none
    real :: a
    real, dimension(2) :: argument
    character(len=2), parameter :: tokens = '+-'
    character :: token
    a = 0
    token = get_token()
    argument(1) = precedence1()
    token = get_token()
    do while (verify(token,tokens) == 0)
       call advance()
       argument(2) = precedence1()
       if (token == '-') argument = argument * (/1, -1/)
       argument(1) = sum(argument)
       token = get_token()
    end do
    a = argument(1)
  end function precedence0

  real function statement()
    implicit none
    if (unfinished()) then
       statement = precedence0()
    else                        !empty okay
       statement = 0
    end if
    if (unfinished()) call parse_error()
  end function statement

  real function evaluate(expression)
    implicit none
    character(len=*), intent(in) :: expression
    text_to_parse = expression
    evaluate = statement()
  end function evaluate

end module evaluate_algebraic_expression


program g24
  use evaluate_algebraic_expression
  implicit none
  integer, dimension(4) :: digits
  character(len=78) :: expression
  real :: result
  ! integer :: i
  call random_seed!easily found internet examples exist to seed by /dev/urandom or time
  call deal(digits)
  ! do i=1, 9999 ! produce the data to test digit distribution
  !   call deal(digits)
  !   write(6,*) digits
  ! end do
  write(6,'(a13,4i2,a26)')'Using digits',digits,', and the algebraic dyadic'
  write(6,*)'operators +-*/() enter an expression computing 24.'
  expression = ' '
  read(5,'(a78)') expression
  if (invalid_digits(expression, digits)) then
     write(6,*)'invalid digits'
  else
     result = evaluate(expression)
     if (nint(result) == 24) then
        write(6,*) result, ' close enough'
     else
        write(6,*) result, ' no good'
     end if
  end if

contains

  logical function invalid_digits(e,d) !verify the digits
    implicit none
    character(len=*), intent(in) :: e
    integer, dimension(4), intent(inout) :: d
    integer :: i, j, k, count
    logical :: unfound
    count = 0
    invalid_digits = .false. !validity assumed
    !write(6,*)'expression:',e(1:len_trim(e))
    do i=1, len_trim(e)
       if (verify(e(i:i),'0123456789') == 0) then
          j = index('0123456789',e(i:i))-1
          unfound = .true.
          do k=1, 4
             if (j == d(k)) then
                unfound = .false.
                exit
             end if
          end do
          if (unfound) then
             invalid_digits = .true.
             !return or exit is okay here
          else
             d(k) = -99
             count = count + 1
          end if
       end if
    end do
    invalid_digits = invalid_digits .or. (count /= 4)
  end function invalid_digits

  subroutine deal(digits)
    implicit none
    integer, dimension(4), intent(out) :: digits
    integer :: i
    real :: harvest
    call random_number(harvest)
    do i=1, 4
       digits(i) = int(mod(harvest*9**i, 9.0))   + 1
    end do
    !    NB. computed with executable Iverson notation, www.jsoftware.oom
    !    #B NB. B are the digits from 9999 deals
    ! 39996
    !    ({.,#)/.~/:~B  # show the distribution of digits
    ! 0 4380
    ! 1 4542
    ! 2 4348
    ! 3 4395
    ! 4 4451
    ! 5 4474
    ! 6 4467
    ! 7 4413
    ! 8 4526
    !    NB. this also shows that I forgot to add 1.  Inserting now...
  end subroutine deal
end program g24
