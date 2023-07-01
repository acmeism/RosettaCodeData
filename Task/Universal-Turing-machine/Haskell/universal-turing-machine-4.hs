beaver "a" 0 = Action 1 MRight "b"
beaver "a" 1 = Action 1 MLeft  "c"
beaver "b" 0 = Action 1 MLeft  "a"
beaver "b" 1 = Action 1 MRight "b"
beaver "c" 0 = Action 1 MLeft  "b"
beaver "c" 1 = Action 1 Stay   "halt"

tape2 = tape 0 [] []
machine2 = runUTM beaver "halt" "a" tape2
