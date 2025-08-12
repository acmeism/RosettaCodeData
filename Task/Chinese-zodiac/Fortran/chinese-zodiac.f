program chinese_zodiac
  implicit none

  ! Define arrays for animals and elements
  character(len=10), dimension(12) :: animals = [character(len=10) :: &
       "Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake", &
       "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig"]
  character(len=10), dimension(5) :: elements = [character(len=10) :: &
       "Wood", "Fire", "Earth", "Metal", "Water"]

  ! Define test years
  integer, parameter :: numyears=9
  integer, dimension(numyears) :: years = [1935, 1938, 1957, 1968, 1972, 1976, 2006, 2017, 2025]
  integer :: i, year
    write(*,'(/)')

  ! Loop through years and print zodiac information
  do i = 1, numyears
     year = years(i)
     write(*, '(I4, A)') year, " is the year of the " // &
          trim(get_element(year)) // " " // &
          trim(get_animal(year)) // " (" // &
          trim(get_yy(year)) // ")."
  end do
    write(*,'(/)')
contains

  ! Function to get the element based on year
  function get_element(year) result(element)
    integer, intent(in) :: year
    character(len=10) :: element
    integer :: idx
!    idx = floor(real((year - 4) / 2) / 5.0) + 1
    idx = floor(real(modulo(year - 4, 10)) / 2.0) + 1
    if (idx < 1) idx = 1
    if (idx > 5) idx = 5
    element = elements(idx)
  end function get_element

  ! Function to get the animal based on year
  function get_animal(year) result(animal)
    integer, intent(in) :: year
    character(len=10) :: animal
    integer :: idx
    idx = modulo(year - 4, 12) + 1
    if (idx < 1) idx = 1
    if (idx > 12) idx = 12
    animal = animals(idx)
  end function get_animal

  ! Function to get yin/yang based on year
  function get_yy(year) result(yy)
    integer, intent(in) :: year
    character(len=4) :: yy
    if (modulo(year, 2) == 0) then
       yy = "yang"
    else
       yy = "yin"
    end if
  end function get_yy

end program chinese_zodiac
