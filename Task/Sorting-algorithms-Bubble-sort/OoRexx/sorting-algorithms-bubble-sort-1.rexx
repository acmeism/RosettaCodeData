/* Rexx */
Do
  placesList = sampleData()
  call show placesList
  say
  sortedList = bubbleSort(placesList)
  call show sortedList
  say

  return
End
Exit

-- -----------------------------------------------------------------------------
bubbleSort:
procedure
Do
  il = arg(1)
  sl = il~copy

  listLen = sl~size
  loop i_ = 1 to listLen
    loop j_ = i_ + 1 to listLen
      cmpi = sl[i_]
      cmpj = sl[j_]
      if cmpi > cmpj then do
        sl[i_] = cmpj
        sl[j_] = cmpi
        end
      end j_
    end i_
  return sl
End
Exit

-- -----------------------------------------------------------------------------
show:
procedure
Do
  al = arg(1)

  loop e_ over al
    say e_
    end e_

  return
End
Exit

-- -----------------------------------------------------------------------------
sampleData:
procedure
Do
  placesList = .array~of( ,
    "UK  London",     "US  New York",   "US  Boston",     "US  Washington", ,
    "UK  Washington", "US  Birmingham", "UK  Birmingham", "UK  Boston"      ,
    )

  return placesList
End
Exit
