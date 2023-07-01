! compilation, linux.  Filename htw.f90
! a=./htw && make $a && $a

! default answers eliminate infinite cycles,
! as does the deal subroutine.

module constants
  implicit none
  integer, parameter :: you = 1
  integer, parameter :: wumpus = 2
  integer, parameter :: pit1 = 3
  integer, parameter :: pit2 = 4
  integer, parameter :: bat1 = 5
  integer, parameter :: bat2 = 6
  character(len=20), parameter :: rooms = 'ABCDEFGHIJKLMNOPQRST'
  character(len=3), dimension(20), parameter :: cave = (/          &
    & 'BEH','ACJ','BDL','CEN','ADF','EGO','FHQ','AGI','HJR','BIK', &
    & 'JLS','CKM','LNT','DMO','FNP','OQT','GPR','IQS','KRT','MPS'  &
    & /)
end module constants

program htw
  use constants
  implicit none
  ! occupied(you:you) is the room letter
  character(len=bat2) :: occupied
!  character(len=22) :: test ! debug  deal
  integer :: arrows
  logical :: ylive, wlive
  ! get instructions out of the way
  if (interact('Do you want instructions (y-n):') .eq. 'Y') then
    call instruct
  end if
  ! initialization
  arrows = 5
  call random_seed()
  call deal(rooms, occupied)
!  call deal(rooms, test)  ! debug  deal
!  write(6,*) test(1:20)   ! debug  deal
  ylive = .true.
  wlive = .true.
  write(6,*) 'Hunt the wumpus'
  do while (ylive .and. wlive)
    call paint(occupied(you:you))
    call warn(occupied)
    if (interact('Move or shoot (m-s):') .eq. 'S') then
      call shoot(occupied)
      arrows = arrows - 1
    else
      call move(occupied)
    end if
    wlive = 0 .lt. (index(rooms, occupied(wumpus:wumpus)))
    ylive = (fate(occupied) .and. (0 .lt. arrows)) .or. (.not. wlive)
  end do
  if (wlive) then
    write(6,*) 'The wumpus lives.  Game over.'
  else
    write(6,*) 'You killed the wumpus lives.  Game over.'
  end if

contains

  subroutine paint(room)
    ! interesting game play when the map must be deciphered
    ! The wumpus map was well known, so it is provided
    implicit none
    character(len=31), dimension(14), parameter :: map = (/ &
      & '     A...................B     ', &
      & '   ..  \               /  .    ', &
      & '   .     H-----I------J    .   ', &
      & '  ..    /      |       \   .   ', &
      & '  .    G _   . R- _     \   .  ', &
      & ' ..   /    Q        -S---K  .  ', &
      & ' .   /     \         /   \   . ', &
      & ' . _-F_     \       /    _L_ . ', &
      & 'E -    \_   /P-----T   _/   \ C', &
      & ' ..       O/        \M/    ... ', &
      & '   ...     \__    _ /   ...    ', &
      & '      ...     \ N/   ...       ', &
      & '         ...    | ...          ', &
      & '            ... D              '  &
      & /)
    character(len=31) :: marked_map
    character(len=1), intent(in) :: room
    integer :: i, j
    write(6,*)
    do i=1, 14
      marked_map = map(i)
      j = index(marked_map, room)
      if (0 < j) then
        marked_map(j:j) = 'y'
      end if
      ! write(6,'(a,6x,a)') map(i), marked_map  ! noisy
      write(6,'(6x,a)') marked_map
    end do
    write(6,*)
    write(6,'(3a/)') 'you are in room ', room, ' marked with y'
  end subroutine paint

  function raise(c) ! usually named "to_upper"
    ! return single character input as upper case
    implicit none
    character(len=1), intent(in) :: c
    character(len=1) :: raise
    character(len=26), parameter :: lower_case = 'abcdefghijklmnopqrstuvwxyz'
    character(len=26), parameter :: upper_case = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    integer :: n
    n = index(lower_case, c)
    if (n .ne. 0) then
      raise = upper_case(n:n)
    else
      raise = c
    end if
  end function raise

  function interact(prompt)
    implicit none
    ! prompt, get answer, return as upper case
    character(len=1) :: interact
    character(len=*), intent(in) :: prompt
    character(len=1) :: answer
    write(6,*) prompt
    read(5,*) answer
    interact = raise(answer)
  end

  subroutine instruct
    implicit none
    write(6,*) 'Welcome to wumpus hunt'
    write(6,*) ''
    write(6,*) 'The wumpus sleeps within a cave of 20 rooms.'
    write(6,*) 'Goal: shoot the wumpus with 1 of 5 crooked arrows.'
    write(6,*) 'Each room has three tunnels leading to other rooms.'
    write(6,*) 'At each turn you can move or shoot up to 5 rooms distant'
    write(6,*) ''
    Write(6,*) 'Hazards:'
    write(6,*) ' 2 rooms have bottomless pits.  Enter and lose.'
    write(6,*) ' 2 rooms have giant bats.  Enter & they carry you elsewhere.'
    write(6,*) ' 1 room holds the wumpus.  Enter and it eats you.'
    write(6,*) ''
    write(6,*) 'Warnings: Entering a room adjoining a hazard'
    write(6,*) ' Pit "I feel a draft"'
    write(6,*) ' Bat "Bat nearby"'
    write(6,*) ' Wumpus "I smell a wumpus"'
    write(6,*) ''
    write(6,*) 'Shooting awakens the wumpus, which moves to an'
    write(6,*) 'adjoining room with (75%) else stays put.'
    write(6,*) 'The wumpus eats you if it enters your space.'
    write(6,*) 'choose arrow path wisely lest you shoot yourself'
  end subroutine instruct

  integer function random_integer(n)
    implicit none
    ! return a random integer from 1 to n
    ! replaces FN[ABC]
    integer, intent(in) :: n
    double precision :: r
    call random_number(r)
    random_integer = 1 + int(r * n)
  end function random_integer

  subroutine deal(deck, hand)
    ! deal from deck into hand ensuring to not run indefinitely
    ! by selecting from set of valid indexes
    implicit none
    character(len=*), intent(in) :: deck
    character(len=*), intent(out) :: hand
    integer, dimension(:), allocatable :: idx
    integer :: k, j, n
    n = len(deck)
    allocate(idx(n))
    do k=1, n
      idx(k) = k
    end do
    do k=1, min(len(deck), len(hand))
      j = random_integer(n)
      hand(k:k) = deck(idx(j):idx(j))
      idx(j:n-1) = idx(j+1:n) ! shift indexes
      n = n - 1
    end do
    deallocate(idx)
  end subroutine deal

  subroutine warn(occupied)
    use constants
    implicit none
    character(len=6), intent(in) :: occupied
    character(len=3) :: neighbors
    neighbors  = cave(index(rooms, occupied(you:you)))
    if (0 .lt. index(neighbors, occupied(wumpus:wumpus))) write(6,*) 'I smell a wumpus!'
    if (0 .lt. (index(neighbors, occupied(pit1:pit1)) + index(neighbors, occupied(pit2:pit2)))) &
      & write(6,*) 'I feel a draft.'
    if (0 .lt. (index(neighbors, occupied(bat1:bat1)) + index(neighbors, occupied(bat2:bat2)))) &
      & write(6,*) 'Bats nearby.'
    ! write(6,*) occupied  ! debug
  end subroutine warn

  subroutine shoot(occupied)
    use constants
    implicit none
    character(len=3), dimension(5), parameter :: ordinal = (/'1st','2nd','3rd','4th','5th'/)
    character(len=6), intent(inout) :: occupied
    character(len=5) :: path
    character(len=3) :: neighbors
    character(len=1) :: arrow ! location
    integer :: i, j, n
    logical :: valid
    n = max(1, index(rooms(1:5), interact('Use what bow draw weight? a--e for 10--50 #s')))
    ! well, this is the intent I understood of the description
    write(6,*) 'define your crooked arrow''s path'
    do i=1, n
      path(i:i) = interact(ordinal(i)//' ')
    end do
    ! verify path
    valid = .true.
    do i=3, n  ! disallow 180 degree turn
      j = i - 1
      valid = valid .and. (path(i:i) .ne. path(j:j))
    end do
    if (.not. valid) write(6,*)'Arrows are''t that crooked!'
    ! author David Lambert
    arrow = occupied(you:you)
    do i=1, n ! verify connectivity
      j = index(rooms, arrow)
      neighbors = cave(j)
      if (0 .lt. index(neighbors, path(i:i))) then
        arrow = path(i:i)
      else
        valid = .false.
      end if
    end do
    if (.not. valid) then ! choose random path, which can include U-turn, lazy.
      do i=1, n
        j = index(rooms, arrow)
        neighbors = cave(j)
        call deal(neighbors, arrow)
        path(i:i) = arrow
      end do
    end if
    ! ... and the arrow
    i = mod(index(path, occupied(you:you)) + 6, 7)
    j = mod(index(path, occupied(wumpus:wumpus)) + 6, 7)
    if (i .lt. j) then
      write(6, *) 'Oooof!  You shot yourself'
      occupied(you:you) = 'x'
    else if (j .lt. i) then
      write(6, *) 'Congratulations!  You slew the wumpus.'
      occupied(wumpus:wumpus) = 'x'
    else ! wumpus awakens, rolls over and back to sleep or moves.
      i = index(rooms, occupied(wumpus:wumpus))
      neighbors = cave(i)
      call deal(neighbors // occupied(wumpus:wumpus), occupied(wumpus:wumpus))
    end if
  end subroutine shoot

  subroutine move(occupied)
    use constants
    implicit none
    character(len=6), intent(inout) :: occupied
    character(len=3) :: neighbors
    integer :: i
    neighbors = cave(index(rooms, occupied(you:you)))
    i = index(neighbors, interact('Where to? '//neighbors//'  defaults to '//neighbors(1:1)))
    i = max(1, i)
    occupied(you:you) = neighbors(i:i)
  end subroutine move

  logical function fate(occupied)
    ! update position of you and bat
    ! return
    use constants
    implicit none
    character(len=6), intent(inout) :: occupied
    character(len=1) :: y, w, p1, p2, b1, b2
    integer :: i
    y = occupied(you:you)
    if (0 .eq. index(rooms, y)) then
      fate = .false.
      return
    end if
    w = occupied(wumpus:wumpus)
    if (0 .eq. index(rooms, w)) then
      fate = .true.
      return
    end if
    p1 = occupied(pit1:pit1)
    p2 = occupied(pit2:pit2)
    b1 = occupied(bat1:bat1)
    b2 = occupied(bat2:bat2)
    ! avoiding endless flight, the bats can end up in same room
    ! these bats reloacate.  They also grab you before falling
    ! into pit.
    if (w .eq. y) then
      write(6,*)'You found the GRUEsome wumpus.  It devours you.'
      fate = .false.
      return
    end if
    if ((b1 .eq. y) .or. (b2 .eq. y)) then
      write(6,*)'A gigantic bat carries you to elsewhereville, returning to it''s roost.'
      i = random_integer(len(rooms))
      y = rooms(i:i)
      occupied(you:you) = y
    end if
    if (w .eq. y) then
      write(6,*)'and drops you into the wumpus''s GRUEtesque fangs'
      fate = .false.
    else if ((p1 .eq. y) .or. (p2 .eq. y)) then
      write(6,*)'you fall into a bottomless pit'
      fate = .false.
    else
      fate = .true.
    end if
  end function fate

end program htw
