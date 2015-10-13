property OMask : missing value
property XMask : missing value
property winningNumbers : {7, 56, 73, 84, 146, 273, 292, 448}
property difficulty : missing value

repeat
   set OMask to 0
   set XMask to 0

   if button returned of (display dialog "Who should start?" buttons {"I shoud", "CPU"}) = "CPU" then set OMask to npcGet()
   set difficulty to button returned of (display dialog "Please choose your difficulty" buttons {"Hard", "Normal"})

   repeat
       set XMask to XMask + 2 ^ (nGet() - 1)
       if winnerForMask(XMask) or OMask + XMask = 511 then exit repeat
       set OMask to npcGet()
       if winnerForMask(OMask) or OMask + XMask = 511 then exit repeat
   end repeat

   if winnerForMask(OMask) then
       set msg to "CPU Wins!"
   else if winnerForMask(XMask) then
       set msg to "You WON!!!"
   else
       set msg to "It's a draw"
   end if

   display dialog msg & return & return & drawGrid() & return & return & "Do you want to play again?"
end repeat

on nGet()
   set theMessage to "It's your turn Player 1, please fill in the number for X" & return & return & drawGrid()
   repeat
       set value to text returned of (display dialog theMessage default answer "")
       if (offset of value in "123456789") is not 0 then
           if not positionIsUsed(value as integer) then exit repeat
       end if
   end repeat
   return value as integer
end nGet

on npcGet()
   --first get the free positions
   set freeSpots to {}
   repeat with s from 1 to 9
       if not positionIsUsed(s) then set end of freeSpots to 2 ^ (s - 1)
   end repeat
   --second check if 1 move can make the CPU win
   repeat with spot in freeSpots
       if winnerForMask(OMask + spot) then return OMask + spot
   end repeat

   if difficulty is "Hard" and OMask is 0 then
       if XMask = 1 or XMask = 4 then return 2
       if XMask = 64 or XMask = 256 then return 128
   end if
   --third check if a user can make make it win (defensive) place it on position
   repeat with spot in freeSpots
       if winnerForMask(XMask + spot) then return OMask + spot
   end repeat

   --fourth check if CPU can win in two moves
   repeat with spot1 in freeSpots
       repeat with spot2 in freeSpots
           if winnerForMask(OMask + spot1 + spot2) then return OMask + spot2
       end repeat
   end repeat
   --fifth check if player can win in two moves
   repeat with spot1 in freeSpots
       repeat with spot2 in reverse of freeSpots
           if winnerForMask(XMask + spot1 + spot2) then return OMask + spot1
       end repeat
   end repeat
   --at last pick a random spot
   if XMask + OMask = 0 and difficulty = "Hard" then return 1

   return OMask + (some item of freeSpots)
end npcGet

on winnerForMask(mask)
   repeat with winLine in winningNumbers
       if BWAND(winLine, mask) = contents of winLine then return true
   end repeat
   return false
end winnerForMask

on drawGrid()
   set grid to ""
   repeat with o from 0 to 8
       if BWAND(OMask, 2 ^ o) = 2 ^ o then
           set grid to grid & "O"
       else if BWAND(XMask, 2 ^ o) = 2 ^ o then
           set grid to grid & "X"
       else
           set grid to grid & o + 1
       end if
       if o is in {2, 5} then set grid to grid & return
   end repeat
   return grid
end drawGrid

on positionIsUsed(pos)
   return BWAND(OMask + XMask, 2 ^ (pos - 1)) = 2 ^ (pos - 1)
end positionIsUsed

on BWAND(n1, n2)
   set theResult to 0
   repeat with o from 0 to 8
       if (n1 mod 2) = 1 and (n2 mod 2) = 1 then set theResult to theResult + 2 ^ o
       set {n1, n2} to {n1 div 2, n2 div 2}
   end repeat
   return theResult as integer
end BWAND
