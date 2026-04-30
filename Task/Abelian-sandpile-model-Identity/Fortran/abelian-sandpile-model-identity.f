!
! Abelian sandpile model/Identity
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.04
!             GNU Fortran (Ubuntu 14.2.0-19ubuntu2) 14.2.0  on Kubuntu 25.04
!             VSI Fortran x86-64 V8.6-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., September 2025
!
  program Abelian
  implicit none

  integer :: av (3,3), s1(3,3), s2(3,3), s3(3,3), s3_id(3,3), result1(3,3), result2(3,3)

  av =  reshape ( [ &       ! Start value for Avalanche
        4,3,3, &
        3,1,2, &
        0,2,3], shape(s3))

  s1 =  reshape ( [ &       ! S1,s2,s3,s3_id as in task description
        1,2,0, &
        2,1,1, &
        0,1,3], shape(s1))
  s2 =  reshape ( [ &
        2,1,3, &
        1,0,1, &
        0,1,0], shape(s2))
  s3 =  reshape ( [ &
        3,3,3, &
        3,3,3, &
        3,3,3], shape(s3))
  s3_id =  reshape ( [ &
        2,1,2, &
        1,0,1, &
        2,1,2], shape(s3_id))



  print '("Avalanche: ")'
  print '("---------- ")'

  call print_it ("Start with ", av)
  do
    if (isStable (av)) then
      print '(A/)', 'is stable.'
      exit
    else
      print '(A/)', 'is not stable.'
    endif
    call topple (av)
    call print_it ("           ", s3)
  end do


  print '(///A)', 'Commutivity:'
  print '(A)',    '------------'

  call print_it ('s1   =    ', s1)
  print *
  call print_it ('s2   =    ', s2)
  print *
  result1 = add(s1,s2)
  call print_it ('s1 + s2 = ', result1)
  print *
  result2 = add(s2,s1)
  call print_it ('s2 + s1 = ', result2)
  print *

  if (isEqual (result1,result2))  then
    print '(A)', 's1 + s2 = s2 + s1 VERIFIED'
  else
    print '(A)', 's1 + s2 = s2 + s1 NOT VERIFIED'
  endif

  print '(///A)', 'Identity:'
  print '(A)',    '---------'

  call print_it ('s3         =    ', s3)
  print *
  call print_it ('s3_id      =    ', s3_ID)
  print *
  result1 = add (s3, s3_id)
  do while ( .not. isstable (result1))
    call topple (result1)
  end do
  call print_it ('s3 + s3_id =    ', result1)
  print *
  if (isEqual (s3,result1))  then
    print '(A/)', 's3 + s3_id = s3 VERIFIED'
  else
    print '(A/)', 's3 + s3_id = s3 NOT VERIFIED'
  endif

  result1 = add (s3_id, s3_id)
  do while ( .not. isstable (result1))
    call topple (result1)
  end do
  call print_it ('s3_id + s3_id =    ', result1)
  print *
  if (isEqual (s3_id, result1))  then
    print '(A)', 's3_id + s3_id = s3_id VERIFIED'
  else
    print '(A)', 's3_id + s3_id = s3_id NOT VERIFIED'
  endif



  contains


  ! -----------------------------------
  ! Check if 2 sand piles are identical
  ! -----------------------------------
  function isEqual (a,b) result (r)

  integer, intent(in) :: a(3,3),B(3,3)
  integer :: ii,jj
  logical :: r

  r = .false.
  do ii=1,3
    do jj=1,3
      if ( a(ii,jj) .ne. b(ii,jj) ) return
    end do
  end do
  r=.true.
  end function isEqual


  ! ----------------------------------------------------------
  ! Print sand pile contents, together with a descriptive text
  ! ----------------------------------------------------------
  subroutine print_it (text, a)

  integer :: a (3,3)

  character (len=*) :: text
  character (len=:), allocatable :: blank

  integer :: ii, jj

  ! create blank string with same length as text
  blank = text
  do ii=1, len (blank)
    blank(ii:ii) = ' '
  end do
  do jj = 1, 3                                ! three lines to print. Note: 2nd index is row, 1st is column
    if (jj .eq. 2) then                       ! Description in middle line
      write (*,'(A)', advance='no')   text
    else
      write (*,'(A)', advance='no')   blank   ! empty space to have same indent for the other lines
    endif
    do ii=1,3                                 ! then the 3 columns of this row
      write (*, '(i1," ")', advance='no')  a(ii,jj)
    end do
    write (*,*)                               ! terminate current line
  end do

  end subroutine print_it


  ! --------------------------------
  ! Add the contents of 2 sand piles
  ! --------------------------------
  function add (a,b) result (c)

  integer, intent(in) :: a (3,3),b(3,3)
  integer  ::c(3,3)

  integer :: ii, jj
    do ii = 1, 3
      do jj=1,3
        c(ii,jj) = a(ii,jj) + b(ii,jj)
      end do
    end do
  end function add


  ! ----------------------------------------------
  ! Check if sand pile is stable (all elements <4)
  ! ----------------------------------------------
  function isStable (a) result(Yes)

  integer, intent(in)  :: a(3,3)
  logical :: Yes
  integer :: ii, jj

  yes = .true.
  do ii = 1, 3
    do jj=1, 3
      if (a(ii,jj) .gt.3) then   ! >3 means not stable.
        Yes = .false.
        return
      end if
    end do
  end do
  end function isStable


  ! ----------------------------------
  ! 1 cycle of toppling of a sand pile
  ! ----------------------------------
  subroutine topple (a)
  implicit none

  integer, intent(inout) :: a (3,3)
  logical :: Yes
  integer :: ii, jj

  do jj = 1, 3                        ! row is second index
    do ii=1,3                         ! col is 1st index
      if (a(ii,jj) .gt.3) then
        a(ii,jj) = a(ii,jj) - 4
        if (ii .gt. 1) a(ii-1,jj) = a(ii-1,jj) + 1
        if (ii .lt. 3) a(ii+1,jj) = a(ii+1,jj) + 1
        if (jj .gt. 1) a(ii,jj-1) = a(ii,jj-1) + 1
        if (jj .lt. 3) a(ii,jj+1) = a(ii,jj+1) + 1
        return
      end if
    end do
  end do
  end subroutine topple

  end program Abelian
