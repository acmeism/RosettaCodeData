program solve_24
  use helpers
  implicit none
  real                 :: vector(4), reals(4), p, q, r, s
  integer              :: numbers(4), n, i, j, k, a, b, c, d
  character, parameter :: ops(4) = (/ '+', '-', '*', '/' /)
  logical              :: last
  real,parameter       :: eps = epsilon(1.0)

  do n=1,12
    call random_number(vector)
    reals   = 9 * vector + 1
    numbers = int(reals)
    call Insertion_Sort(numbers)

    permutations: do
      a = numbers(1); b = numbers(2); c = numbers(3); d = numbers(4)
      reals = real(numbers)
      p = reals(1);   q = reals(2);   r = reals(3);   s = reals(4)
      ! combinations of operators:
      do i=1,4
        do j=1,4
          do k=1,4
            if      ( abs(op(op(op(p,i,q),j,r),k,s)-24.0) < eps ) then
              write (*,*) numbers, ' : ', '((',a,ops(i),b,')',ops(j),c,')',ops(k),d
              exit permutations
            else if ( abs(op(op(p,i,op(q,j,r)),k,s)-24.0) < eps ) then
              write (*,*) numbers, ' : ', '(',a,ops(i),'(',b,ops(j),c,'))',ops(k),d
              exit permutations
            else if ( abs(op(p,i,op(op(q,j,r),k,s))-24.0) < eps ) then
              write (*,*) numbers, ' : ', a,ops(i),'((',b,ops(j),c,')',ops(k),d,')'
              exit permutations
            else if ( abs(op(p,i,op(q,j,op(r,k,s)))-24.0) < eps ) then
              write (*,*) numbers, ' : ', a,ops(i),'(',b,ops(j),'(',c,ops(k),d,'))'
              exit permutations
            else if ( abs(op(op(p,i,q),j,op(r,k,s))-24.0) < eps ) then
              write (*,*) numbers, ' : ', '(',a,ops(i),b,')',ops(j),'(',c,ops(k),d,')'
              exit permutations
            end if
          end do
        end do
      end do
      call nextpermutation(numbers,last)
      if ( last ) then
        write (*,*) numbers, ' : no solution.'
        exit permutations
      end if
    end do permutations

  end do

contains

  pure real function op(x,c,y)
    integer, intent(in) :: c
    real, intent(in)    :: x,y
    select case ( ops(c) )
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

end program solve_24
