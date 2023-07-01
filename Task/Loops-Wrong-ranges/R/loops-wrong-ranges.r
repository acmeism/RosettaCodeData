seq(from = -2, to = 2, by = 1)#Output: -2 -1  0  1  2
seq(from = -2, to = 2, by = 0)#Fails: "invalid '(to - from)/by'"
seq(from = -2, to = 2, by = -1)#Fails: As in the notes above - "Specifying to - from and by of opposite signs is an error."
seq(from = -2, to = 2, by = 10)#Output: -2
seq(from = 2, to = -2, by = 1)#Fails: Same as the third case.
seq(from = 2, to = 2, by = 1)#Output: 2
seq(from = 2, to = 2, by = -1)#Output: 2
seq(from = 2, to = 2, by = 0)#Output: 2
seq(from = 0, to = 0, by = 0)#Output: 0
