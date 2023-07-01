! compilation
! gfortran -std=f2008 -Wall -ffree-form -fall-intrinsics -fimplicit-none f.f08 -o f
!
! EXAMPLE
!
!$ ./f
!rock, paper, scissors?  papier
!scoring computer choice (r) and your choice (p)
!rock, paper, scissors?  sizzerz
!scoring computer choice (s) and your choice (s)
!rock, paper, scissors?  quit
!scoring computer choice (r) and your choice (q)
! Who's keeping score anyway???
!  0.5  1.5
! you won!
!$



program rpsgame

  integer, parameter :: COMPUTER=1, HAPLESSUSER=2
  integer, dimension(3) :: rps = (/1,1,1/)
  real, dimension(3) :: p
  character :: answer, cc ! computer choice
  integer :: exhaustion, i
  real, dimension(2) :: score = (/0, 0/)
  character(len=8), dimension(3) :: choices = (/'rock    ','paper   ','scissors'/)
  real :: harvest
  do exhaustion = 1, 30
    p = rps/real(sum(rps))
    p(2) = p(2) + p(1)
    p(3) = p(3) + p(2)
    call random_number(harvest)
    i = sum(merge(1,0,harvest.le.p)) ! In memory of Ken Iverson, logical is more useful as integer.
    cc = 'rsp'(i:i)
    write(6, "(2(A,', '),A,'?  ')", advance='no')(trim(choices(i)),i=1,size(choices))
    read(5, *) answer
    write(6, "('scoring computer choice (',A,') and your choice (',A,')')")cc,answer
    if (answer.eq.cc) then
      score = score + 0.5
    else
      i = HAPLESSUSER
      if (answer.eq.'r') then
        if (cc.eq.'p') i = COMPUTER
      else if (answer.eq.'p') then
        if (cc.eq.'s') i = COMPUTER
      else if (answer.eq.'s') then
        if (cc.eq.'r') i = COMPUTER
      else
        exit
      endif
      score(i) = score(i) + 1
    end if
    i = scan('rps',answer)
    rps(i) = rps(i) + 1
  end do
  if (25 .lt. exhaustion) write(6, *) "I'm bored out of my skull"
  write(6, *)"Who's keeping score anyway???"
  write(6, '(2f5.1)') score
  if (score(COMPUTER) .lt. score(HAPLESSUSER)) print*,'you won!'
end program rpsgame
