      module ksack2
!
! THIS SUBROUTINE SOLVES THE 0-1 SINGLE KNAPSACK PROBLEM
!
! MAXIMIZE  Z = P(1)*X(1) + ... + P(N)*X(N)
!
! SUBJECT TO:   W(1)*X(1) + ... + W(N)*X(N) .LE. C ,
!               X(J) = 0 OR 1  FOR J=1,...,N.
!
! THE PROGRAM IS INCLUDED IN THE VOLUME
! S. MARTELLO, P. TOTH, "KNAPSACK PROBLEMS: ALGORITHMS
! AND COMPUTER IMPLEMENTATIONS", JOHN WILEY, 1990
! (https://dl.acm.org/doi/book/10.5555/98124)
! AND IMPLEMENTS THE BRANCH-AND-BOUND ALGORITHM DESCRIBED IN
! SECTION  2.5.2 .
! THE PROGRAM DERIVES FROM AN EARLIER CODE PRESENTED IN
! S. MARTELLO, P. TOTH, "ALGORITHM FOR THE SOLUTION OF THE 0-1 SINGLE
! KNAPSACK PROBLEM", COMPUTING, 1978.

! The orignal program was written in Fortran 77 and was an amazing tangle of GOTO statements.
! I have reworked the code in such a manner as to eliminate the GOTO statements and bring it
! to Fortran 2018 LANGUAGE compliance though the code logic remains somewhat untractable.
!
! The routine requires a large parameter string which includes 4 dummy arrays for it's calculations.
! As well, it offers an option to check the input data for correctness.
! Rather than modify the original algorithm, I wrote a simple wrapper called "start_knapsack" that
! allocates those arrays as well as defaulting the input parameter check to "on", hiding them from the user.
! Having said that, the algorithm works very well and is very fast. I've included it in this
! Rosetta Code listing because it scales well and can be used with a large dataset.
! Which a potential user may desire.
! Peter.kelly@acm.org (28-December-2023)
!
! THE INPUT PROBLEM MUST SATISFY THE CONDITIONS
!
!   1) 2 .LE. N .LE. JDIM - 1 ;
!   2) P(J), W(J), C  POSITIVE INTEGERS;
!   3) MAX (W(J)) .LE. C ;
!   4) W(1) + ... + W(N) .GT. C ;
!   5) P(J)/W(J) .GE. P(J+1)/W(J+1) FOR J=1,...,N-1. <-- Note well. They need to be sorted in the greatest ratio of (p(j)/w(j)) down to the smallest one
!
! MT1 CALLS  1  PROCEDURE: CHMT1.
!
! MT1 NEEDS  8  ARRAYS ( P ,  W ,  X ,  XX ,  MIN ,  PSIGN ,  WSIGN
!                        AND  ZSIGN ) OF LENGTH AT LEAST  N + 1 .
!
! MEANING OF THE INPUT PARAMETERS:
! N    = NUMBER OF ITEMS;
! P(J) = PROFIT OF ITEM  J  (J=1,...,N);
! W(J) = WEIGHT OF ITEM  J  (J=1,...,N);
! C    = CAPACITY OF THE KNAPSACK;
! JDIM = DIMENSION OF THE 8 ARRAYS;
! JCK  = 1 IF CHECK ON THE INPUT DATA IS DESIRED,
!      = 0 OTHERWISE.
!
! MEANING OF THE OUTPUT PARAMETERS:
! Z    = VALUE OF THE OPTIMAL SOLUTION IF  Z .GT. 0 ,
!      = ERROR IN THE INPUT DATA (WHEN JCK=1) IF Z .LT. 0 : CONDI-
!        TION  - Z  IS VIOLATED;
! X(J) = 1 IF ITEM  J  IS IN THE OPTIMAL SOLUTION,
!      = 0 OTHERWISE.
!
! ARRAYS XX, MIN, PSIGN, WSIGN AND ZSIGN ARE DUMMY.
!
! ALL THE PARAMETERS ARE INTEGER. ON RETURN OF MT1 ALL THE INPUT
! PARAMETERS ARE UNCHANGED.
!
          implicit none
      contains
          subroutine mt1(n , p , w , c , z , x , jdim , jck , xx , min , psign , wsign , zsign)
              implicit none
              integer :: jdim
              integer :: n
              integer , intent(inout) , dimension(jdim) :: p
              integer , intent(inout) , dimension(jdim) :: w
              integer :: c
              integer , intent(inout) :: z
              integer , intent(out) , dimension(jdim) :: x
              integer , intent(in) :: jck
              integer , intent(inout) , dimension(jdim) :: xx
              integer , intent(inout) , dimension(jdim) :: min
              integer , intent(inout) , dimension(jdim) :: psign
              integer , intent(inout) , dimension(jdim) :: wsign
              integer , intent(inout) , dimension(jdim) :: zsign
!
              real :: a
              real :: b
              integer :: ch
              integer :: chs
              integer :: diff
              integer :: ii
              integer :: ii1
              integer :: in
              integer :: ip
              integer :: iu
              integer :: j
              integer :: j1
              integer :: jj
              integer :: jtemp
              integer :: kk
              integer :: lim
              integer :: lim1
              integer :: ll
              integer :: lold
              integer :: mink
              integer :: n1
              integer :: nn
              integer :: profit
              integer :: r
              integer :: t
              integer :: next_code_block
!*Code
              next_code_block = 1
dispatch_loop: do
                  select case(next_code_block)
                  case(1)
                      z = 0
                      if( jck==1 )call chmt1(n , p , w , c , z , jdim)
                      if( z<0 )return
! INITIALIZE.
                      ch = c
                      ip = 0
                      chs = ch
          first_loop: do ll = 1 , n
                          if( w(ll)>chs )exit first_loop
                          ip = ip + p(ll)
                          chs = chs - w(ll)
                      end do first_loop
                      ll = ll - 1
                      if( chs==0 )then
                          z = ip
                          x(1:ll) = 1
                          nn = ll + 1
                          x(nn:n) = 0
                          return
                      else
                          p(n + 1) = 0
                          w(n + 1) = ch + 1
                          lim = ip + chs*p(ll + 2)/w(ll + 2)
                          a = w(ll + 1) - chs
                          b = ip + p(ll + 1)
                          lim1 = b - a*float(p(ll))/float(w(ll))
                          if( lim1>lim )lim = lim1
                          mink = ch + 1
                          min(n) = mink
                          do j = 2 , n
                              kk = n + 2 - j
                              if( w(kk)<mink )mink = w(kk)
                              min(kk - 1) = mink
                          end do
                          xx(1:n) = 0
                          z = 0
                          profit = 0
                          lold = n
                          ii = 1
                          next_code_block = 4
                          cycle dispatch_loop
                      end if
                  case(2)
! TRY TO INSERT THE II-TH ITEM INTO THE CURRENT SOLUTION.
                      do while ( w(ii)>ch )
                          ii1 = ii + 1
                          if( z>=ch*p(ii1)/w(ii1) + profit )then
                              next_code_block = 5
                              cycle dispatch_loop
                          end if
                          ii = ii1
                      end do
! BUILD A NEW CURRENT SOLUTION.
                      ip = psign(ii)
                      chs = ch - wsign(ii)
                      in = zsign(ii)
                      ll = in
                      do while ( ll<=n )
                          if( w(ll)>chs )then
                              iu = chs*p(ll)/w(ll)
                              ll = ll - 1
                              if( iu==0 )then
                                  next_code_block = 3
                                  cycle dispatch_loop
                              end if
                              if( z>=profit + ip + iu )then
                                  next_code_block = 5
                                  cycle dispatch_loop
                              end if
                              next_code_block = 4
                              cycle dispatch_loop
                          else
                              ip = ip + p(ll)
                              chs = chs - w(ll)
                          end if
                      end do
                      ll = n
                      next_code_block = 3
                  case(3)
                      if( z>=ip + profit )then
                          next_code_block = 5
                          cycle dispatch_loop
                      end if
                      z = ip + profit
                      nn = ii - 1
                      x(1:nn) = xx(1:nn)
                      x(ii:ll) = 1
                      if( ll/=n )then
                          nn = ll + 1
                          x(nn:n) = 0
                      end if
                      if( z/=lim )then
                          next_code_block = 5
                          cycle dispatch_loop
                      end if
                      return
                  case(4)
! SAVE THE CURRENT SOLUTION.
                      wsign(ii) = ch - chs
                      psign(ii) = ip
                      zsign(ii) = ll + 1
                      xx(ii) = 1
                      nn = ll - 1
                      if( nn>=ii )then
                          do j = ii , nn
                              wsign(j + 1) = wsign(j) - w(j)
                              psign(j + 1) = psign(j) - p(j)
                              zsign(j + 1) = ll + 1
                              xx(j + 1) = 1
                          end do
                      end if
                      j1 = ll + 1
                      wsign(j1:lold) = 0
                      psign(j) = 0
                      zsign(j1:lold) = [(jtemp, jtemp = j1,lold)]
                      lold = ll
                      ch = chs
                      profit = profit + ip
                      if( ll<(n - 2) )then
                          ii = ll + 2
                          if( ch>=min(ii - 1) )then
                              next_code_block = 2
                              cycle dispatch_loop
                          end if
                      else if( ll==(n - 2) )then
                          if( ch>=w(n) )then
                              ch = ch - w(n)
                              profit = profit + p(n)
                              xx(n) = 1
                          end if
                          ii = n - 1
                      else
                          ii = n
                      end if
! SAVE THE CURRENT OPTIMAL SOLUTION.
                      if( z<profit )then
                          z = profit
                          x(1:n) = xx(1:n)
                          if( z==lim )return
                      end if
                      if( xx(n)/=0 )then
                          xx(n) = 0
                          ch = ch + w(n)
                          profit = profit - p(n)
                      end if
                      next_code_block = 5
                  case(5)
           outer_loop: do ! BACKTRACK.
                          nn = ii - 1
                          if( nn==0 )return
               middle_loop: do j = 1 , nn
                              kk = ii - j
                              if( xx(kk)==1 )then
                                  r = ch
                                  ch = ch + w(kk)
                                  profit = profit - p(kk)
                                  xx(kk) = 0
                                  if( r<min(kk) )then
                                      nn = kk + 1
                                      ii = kk
! TRY TO SUBSTITUTE THE NN-TH ITEM FOR THE KK-TH.
                            inner_loop: do while ( z<profit + ch*p(nn)/w(nn) )
                                          diff = w(nn) - w(kk)
                                          if( diff<0 )then
                                              t = r - diff
                                              if( t>=min(nn) )then
                                                  if( z>=profit + p(nn) + t*p(nn + 1)/w(nn + 1) )exit inner_loop
                                                  ch = ch - w(nn)
                                                  profit = profit + p(nn)
                                                  xx(nn) = 1
                                                  ii = nn + 1
                                                  wsign(nn) = w(nn)
                                                  psign(nn) = p(nn)
                                                  zsign(nn) = ii
                                                  n1 = nn + 1
                                                  wsign(n1:lold) = 0
                                                  psign(n1:lold) = 0
                                                  zsign(n1:lold) = [(jtemp, jtemp = n1,lold)]
                                                  lold = nn
                                                  next_code_block = 2
                                                  cycle dispatch_loop
                                              end if
                                          else if( diff/=0 )then
                                              if( diff<=r )then
                                                  if( z<profit + p(nn) )then
                                                      z = profit + p(nn)
                                                      x(1:kk) = xx(1:kk)
                                                      jj = kk + 1
                                                      x(jj:n) = 0
                                                      x(nn) = 1
                                                      if( z==lim )return
                                                      r = r - diff
                                                      kk = nn
                                                      nn = nn + 1
                                                      cycle inner_loop
                                                  end if
                                              end if
                                          end if
                                          nn = nn + 1
                                      end do inner_loop
                                      cycle outer_loop
                                  else
                                      ii = kk + 1
                                      next_code_block = 2
                                      cycle dispatch_loop
                                  end if
                              end if
                          end do middle_loop
                          exit outer_loop
                      end do outer_loop
                      exit dispatch_loop
                  end select
              end do dispatch_loop
          end subroutine mt1
!
          subroutine chmt1(n , p , w , c , z , jdim)
              integer , intent(in) :: jdim
              integer , intent(in) :: n
              integer , intent(in) , dimension(jdim) :: p
              integer , intent(in) , dimension(jdim) :: w
              integer , intent(in) :: c
              integer , intent(out) :: z
!
! Local variable declarations
!
              integer :: j
              integer :: jsw
              real :: r
              real :: rr
!
! CHECK THE INPUT DATA.
!
              if(( n<2) .or. (n>jdim - 1) )then
                  z = -1
                  return
              else if( c>0 )then
                  jsw = 0
                  rr = float(p(1))/float(w(1))
                  do j = 1 , n
                      r = rr
                      if(( p(j)<=0 ).or.( w(j)<=0 ))then
                          z = -2
                          return
                      end if
                      jsw = jsw + w(j)
                      if( w(j)<=c )then
                          rr = float(p(j))/float(w(j))
                          if( rr>r )then
                              z = -5
                              return
                          end if
                      else
                          z = -3
                          return
                      end if
                  end do
                  if( jsw>c )return
                  z = -4
                  return
              end if
            z = -2
            return
          end subroutine chmt1

          subroutine start_knapsack(n , profit , weight , capacity , result_val , members)
!
! Dummy argument declarations
!
              integer , intent(in) :: n
              integer , intent(inout) , dimension(n) :: profit
              integer , intent(inout) , dimension(n) :: weight
              integer , intent(in) :: capacity
              integer , intent(inout) :: result_val
              integer , intent(inout) , dimension(n) :: members
!
! Local variable declarations
              integer :: bigger
              integer :: jck
              integer , allocatable , dimension(:) :: mini
              integer , allocatable , dimension(:) :: psign
              integer , allocatable , dimension(:) :: wsign
              integer , allocatable , dimension(:) :: xx
              integer , allocatable , dimension(:) :: zsign
!
!Designed to invoke MT1
!MT1 NEEDS  8  ARRAYS ( P ,  W ,  X ,  XX ,  MIN ,  PSIGN ,  WSIGN
!                        AND  ZSIGN ) OF LENGTH AT LEAST  N + 1 .

! MEANING OF THE INPUT PARAMETERS:
! N    = NUMBER OF ITEMS;
! P(J) = PROFIT OF ITEM  J  (J=1,...,N);
! W(J) = WEIGHT OF ITEM  J  (J=1,...,N);
! C    = CAPACITY OF THE KNAPSACK;
! JDIM = DIMENSION OF THE 8 ARRAYS;
! JCK  = 1 IF CHECK ON THE INPUT DATA IS DESIRED,
!      = 0 OTHERWISE.
!
! MEANING OF THE OUTPUT PARAMETERS:
! Z    = VALUE OF THE OPTIMAL SOLUTION IF  Z .GT. 0 ,
!      = ERROR IN THE INPUT DATA (WHEN JCK=1) IF Z .LT. 0 : CONDI-
!        TION  - Z  IS VIOLATED;
! X(J) = 1 IF ITEM  J  IS IN THE OPTIMAL SOLUTION,
!      = 0 OTHERWISE.
!
! ARRAYS XX, MIN, PSIGN, WSIGN AND ZSIGN ARE DUMMY.
!
! ALL THE PARAMETERS ARE INTEGER. ON RETURN OF MT1 ALL THE INPUT
! PARAMETERS ARE UNCHANGED.
!
              jck = 1   !Set parameter checking on
              bigger = n + 100
!
!        Allocate the dummy arrays
              allocate(xx(bigger))
              allocate(mini(bigger))
              allocate(psign(bigger))
              allocate(wsign(bigger))
              allocate(zsign(bigger))
              call mt1(n , profit , weight , capacity , result_val , members , bigger , jck , xx , mini , psign , wsign , zsign)
              deallocate(xx)
              deallocate(mini)
              deallocate(psign)
              deallocate(wsign)
              deallocate(zsign)

          end subroutine start_knapsack
      end module ksack2
!
program serious_knapsack
    use ksack2
    integer, parameter :: list_size=22
    integer:: p(list_size) ! The weights
    integer::n,profit(list_size),capacity,result_val,members(size(p)),valuez,t1,t2,j
    character(len=25) :: names(list_size),tempnam
    real :: ratio(list_size),rats
    logical :: swapped
    capacity =400
    members = 0
    result_val = 0
    n = list_size
    p(1:list_size) =     (/13,153, 50,15,68,27,39,23,52,11,32,24,48,73,43,42,22,07,18,009,04,30/)
    profit(1:list_size) =(/35,200,160,60,45,60,40,30,10,70,30,15,10,40,70,75,80,20,12,150,50,10/)

    names(1:22) =[character(len=25) ::'compass','water','sandwich','glucose','tin','banana','apple', 'cheese', &
    'beer','suntan cream','camera','T-shirt','trousers','umbrella','waterproof trousers', 'waterproof overclothes', &
    'note-case','sunglasses','towel','map','socks', 'book']
    ratio(1:22) = float(profit(1:22))/float(p(1:22))
    ! The mt1 algorithm wants the data sorted downwards(large-->small) by the ration of profit/weight
    ! So, I implemented a quick bubble sort to order the lists
    swapped = .true.
    do while (swapped)
        swapped = .false.
        do j = 1,21
            if(ratio(j).lt.ratio(j+1))then ! Swaps everywhere
                swapped = .true.
                t1 = p(j+1)   ! Swap the weights
                p(j+1) = p(j)
                p(j) = t1
                t2 = profit(j+1) !Swap the profits
                profit(j+1) = profit(j)
                profit(j) = t2
                tempnam = names(j+1) ! Swap the names around
                names(j+1) = names(j)
                names(j) = tempnam
                rats = ratio(j+1)   ! Swap the ratios
                ratio(j+1) = ratio(j)
                ratio(j) = rats
            endif
        end do
    end do
    !
    call system_clock(count=xx)
    call startup(n,profit(1:22),p(1:22),capacity,result_val,members)
    call system_clock(count=yy)
    print*,'Total of the sack = ',result_val
    capacity = 0
    valuez = 0
    n = 0
    do i = 1,size(members)
        if(members(i) /=0)then
            capacity = capacity +p(i)
            valuez = profit(i) + valuez
            n = n+1
            print*, names(i),p(i),profit(i)
        endif

    end do
    print*,'Filled capacity = ',capacity,'Value = ',valuez!,'No items = ',n,sum(profit(1:22)),sum(p(1:22))
    print*
    print*,'First knapsack time = ',(yy-xx),'Milliseconds'
    stop 'All done'
end program serious_knapsack
