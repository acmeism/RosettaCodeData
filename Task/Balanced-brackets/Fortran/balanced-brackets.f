! $ gfortran -g -O0 -std=f2008 -Wall f.f08 -o f.exe
! $ ./f
!  compiles             syntax error
! :
! :                     ][
! :                     ]][[
! :[[[]]]
! :                     ][[][]][
! :                     ][[]]][[[]
! :                     ]]]][]][[[[[
! :                     ]]]][][]][[[[[
! :                     ][[[]]]]][]][[[[
! :                     [[][]]][]]][[[][[]
! :                     ]]][[][[[[[[[[]]]]]]
! :[[][[[][]]][]]
! :[[[][]][][[[]][]][]]

program balanced_brackets
  implicit none
  integer :: N
  character(len=20) :: brackets, fmt
  write(6,*)'compiles             syntax error'
  call random_seed
  do N=0, 10
     call generate(N, brackets)
     if (balanced(brackets)) then
        fmt = '(a,a20)'
     else
        fmt = '(a,21x,a20)'
     end if
     write(6,fmt)':',brackets
  end do

  brackets = '[[][[[][]]][]]'
  if (balanced(brackets)) then
     fmt = '(a,a20)'
  else
     fmt = '(a,21x,a20)'
  end if
  write(6,fmt)':',brackets

  N = 10
  call generate(N, brackets)
  do while (.not. balanced(brackets)) ! show a balanced set
     call generate(N, brackets)
  end do
  fmt = '(a,a20)'
  write(6,fmt)':',brackets

contains

  logical function balanced(s)
    implicit none
    character(len=*), intent(in) :: s
    integer :: i, a, n
    n = len_trim(s)
    a = 0
    balanced = .true.
    do i=1, n
       if (s(i:i) == '[') then
          a = a+1
       else
          a = a-1
       end if
       balanced = balanced .and. (0 <= a)
    end do
  end function balanced

  subroutine generate(N, s)
    implicit none
    integer, intent(in) :: N
    character(len=*), intent(out) :: s
    integer :: L, R, i
    real, dimension(2*N) :: harvest
    character :: c
    i = 1
    L = 0
    R = 0
    s = ' '
    call random_number(harvest)
    do while ((L < N) .and. (R < N))
       if (harvest(i) < 0.5) then
          L = L+1
          s(i:i) = '['
       else
          R = R+1
          s(i:i) = ']'
       end if
       i = i+1
    end do
    c = merge('[', ']', L < N)
    do while (i <= 2*N)
       s(i:i) = c
       i = i+1
    end do
  end subroutine generate
end program balanced_brackets
