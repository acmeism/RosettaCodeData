program KNAPSACK_CONTINUOUS
  implicit none

  real, parameter :: maxweight = 15.0
  real :: total_weight = 0, total_value = 0, frac
  integer :: i, j

  type Item
    character(7) :: name
    real :: weight
    real :: value
  end type Item

  type(Item) :: items(9), temp

  items(1) = Item("beef",    3.8, 36.0)
  items(2) = Item("pork",    5.4, 43.0)
  items(3) = Item("ham",     3.6, 90.0)
  items(4) = Item("greaves", 2.4, 45.0)
  items(5) = Item("flitch",  4.0, 30.0)
  items(6) = Item("brawn",   2.5, 56.0)
  items(7) = Item("welt",    3.7, 67.0)
  items(8) = Item("salami",  3.0, 95.0)
  items(9) = Item("sausage", 5.9, 98.0)

  ! sort items in descending order of their value per unit weight
  do i = 2, size(items)
     j = i - 1
     temp = items(i)
     do while (j>=1 .and. items(j)%value / items(j)%weight < temp%value / temp%weight)
       items(j+1) = items(j)
       j = j - 1
     end do
    items(j+1) = temp
  end do

  i = 0
  write(*, "(a4, a13, a6)") "Item", "Weight", "Value"
  do while(i < size(items) .and. total_weight < maxweight)
    i = i + 1
    if(total_weight+items(i)%weight < maxweight) then
      total_weight = total_weight + items(i)%weight
      total_value = total_value + items(i)%value
      write(*, "(a7, 2f8.2)") items(i)
    else
      frac = (maxweight-total_weight) / items(i)%weight
      total_weight = total_weight + items(i)%weight * frac
      total_value = total_value + items(i)%value * frac
      write(*, "(a7, 2f8.2)") items(i)%name, items(i)%weight * frac, items(i)%value * frac
    end if
  end do

  write(*, "(f15.2, f8.2)") total_weight, total_value

end program KNAPSACK_CONTINUOUS
