/* Rexx */
Do
  placesList. = ''
  sortedList. = ''
  call sampleData
  call bubbleSort

  do i_ = 1 to placesList.0
    say placesList.i_
    end i_
  say

  do i_ = 1 to sortedList.0
    say sortedList.i_
    end i_
  say

  return
End
Exit

/* -------------------------------------------------------------------------- */
bubbleSort:
procedure expose sortedList. placesList.
Do
  /* Copy list */
  do !_ = 0 to placesList.0
    sortedList.!_ = placesList.!_
    end !_

  listLen = sortedList.0
  do i_ = 1 to listLen
    do j_ = i_ + 1 to listLen
      if sortedList.i_ > sortedList.j_ then do
        !_            = sortedList.j_
        sortedList.j_ = sortedList.i_
        sortedList.i_ = !_
        end
      end j_
    end i_
  return
End
Exit

/* -------------------------------------------------------------------------- */
sampleData:
procedure expose placesList.
Do
  ! = 0
  ! = ! + 1; placesList.0 = !; placesList.! = "UK  London"
  ! = ! + 1; placesList.0 = !; placesList.! = "US  New York"
  ! = ! + 1; placesList.0 = !; placesList.! = "US  Boston"
  ! = ! + 1; placesList.0 = !; placesList.! = "US  Washington"
  ! = ! + 1; placesList.0 = !; placesList.! = "UK  Washington"
  ! = ! + 1; placesList.0 = !; placesList.! = "US  Birmingham"
  ! = ! + 1; placesList.0 = !; placesList.! = "UK  Birmingham"
  ! = ! + 1; placesList.0 = !; placesList.! = "UK  Boston"

  return
End
Exit
