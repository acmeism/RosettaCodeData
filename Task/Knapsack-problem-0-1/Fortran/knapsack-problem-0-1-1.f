Program Knapsack01
! Translation of Pascal version on Rosetta Code.
  implicit none
  integer, parameter :: NUM_ITEMS = 22
  integer, parameter :: MAX_WEIGHT = 400
  type :: TItem
    character(len=20) :: Name
    integer :: Weight, Value
  end type TItem
  type(TItem), dimension(0:NUM_ITEMS-1) :: ITEMS
  integer, dimension(0:NUM_ITEMS, 0:MAX_WEIGHT) :: D
  integer :: I, W, V, MaxWeight
  ! Init Arrays
  d = 0
  ITEMS =  [ TItem('compass', 13, 35), &
            TItem('water', 153, 200), &
            TItem('sandwich', 50, 160), &
            TItem('glucose', 15, 60), &
            TItem('tin', 68, 45), &
            TItem('banana', 27, 60), &
            TItem('apple', 39, 40), &
            TItem('cheese', 23, 30), &
            TItem('beer', 52, 10), &
            TItem('suntan cream', 11, 70), &
            TItem('camera', 32, 30), &
            TItem('T-shirt', 24, 15), &
            TItem('trousers', 48, 10), &
            TItem('umbrella', 73, 40), &
            TItem('waterproof trousers', 43, 70), &
            TItem('waterproof overclothes', 42, 75), &
            TItem('note-case', 22, 80), &
            TItem('sunglasses', 7, 20), &
            TItem('towel', 18, 12), &
            TItem('map', 9, 150), &
            TItem('socks', 4, 50), &
            TItem('book', 30, 10) ]
    !
  do I = 0, NUM_ITEMS-1
    do W = 0, MAX_WEIGHT
      if (ITEMS(I)%Weight > W) then
        D(I+1, W) = D(I, W)
      else
        D(I+1, W) = max(D(I, W), D(I, W - ITEMS(I)%Weight) + ITEMS(I)%Value)
      end if
    end do
  end do
  W = MAX_WEIGHT
  V = D(NUM_ITEMS, W)
  MaxWeight = 0
    !
  write(*, "(/,'bagged:')")
  do I = NUM_ITEMS-1, 0, -1 !Pete
    if (D(I+1, W) == V) then
        if((D(I, (W - ITEMS(I)%Weight)) == V - ITEMS(I)%Value)) then
      write(*, "('  ', A,t25,i0,t35,i0)", advance='yes') ITEMS(I)%Name,ITEMS(I)%weight,ITEMS(I)%value
      MaxWeight = MaxWeight + ITEMS(I)%Weight
      W = W - ITEMS(I)%Weight
      V = V - ITEMS(I)%Value
        end if
        end if
  end do
    !
  write(*, "('value  = ', I0)") D(NUM_ITEMS, MAX_WEIGHT)
  write(*, "('weight = ', I0)") MaxWeight
end program Knapsack01
