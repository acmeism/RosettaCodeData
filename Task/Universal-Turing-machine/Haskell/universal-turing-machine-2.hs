incr "q0" 1 = Action 1 MRight "q0"
incr "q0" 0 = Action 1 Stay "qf"

tape1 = tape 0 [] [1,1, 1]
machine1 = runUTM incr "qf" "q0" tape1
