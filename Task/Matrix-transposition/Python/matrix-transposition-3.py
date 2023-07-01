# Uneven list of lists
uls = [[10, 11], [20], [], [30, 31, 32]]

print (
    list(zip(*uls))
)

#  --> []
