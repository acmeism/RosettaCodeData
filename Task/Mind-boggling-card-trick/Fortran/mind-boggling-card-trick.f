! Mind boggling card trick
! tested with Intel ifx (IFX) 2025.2.1 20250806             on Kubuntu 25.10
!             GNU Fortran (Ubuntu 15.2.0-4ubuntu4) 15.2.0   on Kubuntu 25.10
!             VSI Fortran x86-64 V8.7-001                   on OpenVMS x86_64 V9.2-3
! No Non-standard features used, should compile on any fairly recent Fortran.
! U.B., February 2026
!=========================================================================================
program CardTrick

implicit none

integer, dimension(52)   :: Cards                         ! The original deck of 52 cards
integer, dimension(52)   :: Reds, Blacks                  ! THe two piles where the magician deals half of the deck
integer, dimension(52)   ::  RedBunch, BlackBunch         ! THe two bunches with X cards to be exchanged between the two piles

! Helpers
integer :: i, j                                           ! Do Loop indices
integer ::  ir, ib                                        ! Indices into the Red and the Black Piles
integer :: x                                              ! The number of cards to exchange between the piles
integer ::  ic, c                                         ! Position and value of a single cards (used at several occasions)
integer ::  irb, ibb                                      ! Index into the Red and the Black exchange Bunch
integer ::  countRedinRed, countBlackinBlack, unusedCtr   ! Count red and red cards in the final piles: reds in red, blacks in blacks. One dummy.

! Note on the Data Model:
! Numbers 1...52 represent 52 cards of the deck
! By definition: we treat odd numbers are RED, and even numbers are BLACK.
! The Values of the cards (e.g. Ace of Hearts) is not interesting here.

! Initialize random number generator once for the entire run-time of the program and all test cases
call random_seed()


! The following steps simulate the card trick.
!
! Create a common deck of cards of 52 cards   (which are half red, half black).
!
do i=1,52
  Cards(i) = i
  Reds(i) = 0
  Blacks(i) = 0
enddo

!     2. Give the pack a good shuffle.
call sattolo_cycle (Cards, 52)                    ! Give the pack a good shuffle.

! Deal from the shuffled deck, you'll be creating three piles.
! ---------------------------------------------------------------
ir = 0
ib = 0

do i=1, 51, 2                             ! Look at every second card
  if (isRed (Cards(i)))    then           ! If this card is RED
    ir = ir + 1                           !   then add the   next   card (unseen) to the   "red"  pile.
    Reds(ir) = Cards(i+1)
  else                                    ! If this card is BLACK
    ib = ib + 1                           !   then add the   next   card (unseen) to the   "black"  pile.
    Blacks (ib) = Cards(i+1)
  endif
end do                                    ! Repeat the above for the rest of the shuffled deck.

! Choose a random number   (call it X)   that will be used to swap cards from the "red" and "black" piles.
x = randominInterval (0,min(ir-1, ib-1))  ! x must be smaller than the smaller number of reds ir and blacks ib, and yes, also 0 is an option.

irb=0
ibb=0
do i=1,X                                  ! Randomly choose X cards ...
  do                                      ! ...    from the   "red"  pile (unseen), let's call this the   "red"  bunch.
    ic = randominInterval (1, ir)
    c = Reds (ic)
    if (c .eq. 0 .or. alreadyKnown (RedBunch, c, ir) ) cycle  ! Avoid selecting a card for a second time
    exit                                                      ! OK, can use this.
  enddo
  irb = irb + 1
  RedBunch (irb) = c                      ! Add the card to the red bunch
  Reds (ic) = 0                           ! ... and Remove it from the Red pile

  do                                      ! ...  from the "black" pile (unseen), let's call this the "black" bunch.
    ic = randominInterval (1, ib)
    c = blacks (ic)
    if (c .eq. 0 .or. alreadyKnown (blackBunch, c, ib) ) cycle
    exit
  enddo
  ibb = ibb + 1
  BlackBunch (ibb) = c    ! Add the card to the black bunch
  Blacks (ic) = 0         ! Remove from the Red pile
enddo

! Put the     "red"    bunch into the   "black" pile.
do i=1, irb
  do j=1, 52        ! Find an empty location in the Black pile
    if (Blacks(j) .eq. 0) then
      Blacks(j) = redBunch (i)
      exit
    endif
  end do
enddo
! Put the   "black"   bunch into the     "red"  pile.
do i=1, ibb
  do j=1, 52        ! Find an empty location in the Red pile
    if (Reds(j) .eq. 0) then
      Reds(j) = BlackBunch (i)
      exit
    endif
  end do
enddo

call count (Reds, ir, countRedinRed, unusedCtr)
write ( *, '(A, i2, A, i2, A)')  'In the red pile there are   ', countRedinRed , ' red cards and ', unusedCtr, ' black cards'
call count (Blacks, ib, unusedCtr, countBlackinBlack)
write ( *, '(A, i2, A, i2, A)')  'In the black pile there are ', unusedCtr ,     ' red cards and ', countBlackinBlack, ' black cards'

if (countBlackinBlack .eq. countRedinRed) then
  write (*, '(A, i2, a, i2, a)') 'Approved: the number of ' , countBlackinBlack , ' black cards in the "black" pile equals the number ', &
    countBlackinBlack, ' of red cards in the "red" pile.'
else
  ! It has been proven that the twoo numbers always are equal, so we won't come her. Anyway:
  write (*, '(A, i2, a, i2, a)') 'Not approved: the number of ' , countBlackinBlack , ' black cards in the "black" pile is not equal to the number ', &
    countBlackinBlack, ' of red cards in the "red" pile.'

endif
contains


! ======================================================
! Check if a card c is already contained in card bunch B
! ======================================================
function alreadyKnown (B,c,n) result (yesitis)
integer, intent(in) :: n, C
integer, dimension(n), intent(in) :: B
logical :: yesitis
integer :: ii
do ii = 1, N                      ! Loop until found or all cards in B are checked.
  if (B(ii) .eq. c) then
    yesitis = .true.
    return
  endif
enddo
yesitis = .false.
end function alreadyKnown

! ================================================
! A Card is red if its number is not 0 and its odd
! ================================================
function isRed (t) result (itis)
integer, intent(in) :: t
logical :: itis
itis = t .ne. 0 .and. mod(t,2) .ne. 0   ! odd numbers are RED.
end function isred

! ===============================================================
! A Card is black if its number is not 0 and its even
! Note:
! The "Not 0" condition makes it different from (.not. isRed(...))
! ================================================================
function isBlack (t) result (itis)
integer, intent(in) :: t
logical :: itis
itis = t .ne. 0 .and. mod(t,2) .eq. 0   ! odd numbers are RED, even is BLACK
end function isBlack


! ================================================
! Count black and red cards in a deck a of n cards.
! ================================================
subroutine count (a, n, red, black)

integer , dimension(n), intent(in) :: a
integer, intent(in) :: n
integer, intent(out) :: red, black
integer :: ii

red=0
black=0
do ii=1,N
  if (isred (a(ii)) )  then
    red = red + 1
  else if (isBlack (a(ii))) then
    black = black + 1
  endif
end do

end subroutine count


!====================================
! shuffle using the Sattolo algorithm
!====================================
subroutine sattolo_cycle (a, d)
integer, intent(in) :: d
integer, dimension(d) , intent (inout) :: a           ! The array to shuffle

integer :: tmp                                        ! for swapping single elements
integer :: j, k, l                                    ! Helper variables: indices into the array, array's length

l =  size (a)
do j = l, 1, -1                                       ! For all letters from end down to begin
  k = randominInterval (1, j-1)                       ! Select random lnumber between 1 and j-1
  tmp = a(j)                                          ! then swap letter at pos j with letter at pos k
  a (j) = a (k)
  a(k) = tmp
end do

end subroutine sattolo_cycle

! ===========================================================
! Generate random number between @lo and @hi (inclusive)
! Assume Random Number Generator has been initialized before.
! ===========================================================
function randominInterval (lo, hi) result (r)
integer, intent(in) :: lo, hi                         ! the interval
integer :: r                                          ! resultant (pseudo-)random number
real :: rnd                                           ! Fortran random number generator generates float values
call random_number (rnd)                              ! 0. <= rnd < 1.
r = lo + FLOOR((hi+1-lo)*rnd)                         ! We want to choose one between [lo,hi]: add +1 to possibly include "hi".
end function randominInterval

end program CardTrick
