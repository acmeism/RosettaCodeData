sorting "A" 1 = Action 1 MRight "A"
sorting "A" 2 = Action 3 MRight "B"
sorting "A" 0 = Action 0 MLeft  "E"
sorting "B" 1 = Action 1 MRight "B"
sorting "B" 2 = Action 2 MRight "B"
sorting "B" 0 = Action 0 MLeft  "C"
sorting "C" 1 = Action 2 MLeft  "D"
sorting "C" 2 = Action 2 MLeft  "C"
sorting "C" 3 = Action 2 MLeft  "E"
sorting "D" 1 = Action 1 MLeft  "D"
sorting "D" 2 = Action 2 MLeft  "D"
sorting "D" 3 = Action 1 MRight "A"
sorting "E" 1 = Action 1 MLeft  "E"
sorting "E" 0 = Action 0 MRight "STOP"

tape3 = tape 0 [] [2,2,2,1,2,2,1,2,1,2,1,2,1,2]
machine3 = runUTM sorting "STOP" "A" tape3
