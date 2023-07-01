# One-liner
# print('\n'.join([''.join(["%3d : %-3s" % (a, 'Spc' if a == 32 else 'Del' if a == 127 else chr(a)) for a in lst]) for lst in [[i+c*16 for c in range(6)] for i in range(32, 47+1)]])

## Detailed version

# List of 16 lists of integers corresponding to
# each row of the table
rows_as_ints = [[i+c*16 for c in range(6)] for i in range(32, 47+1)]

# Function for converting numeric value to string
codepoint2str = lambda codepoint: 'Spc' if codepoint == 32 else 'Del' if codepoint == 127 else chr(codepoint)

rows_as_strings = [["%3d : %-3s" % (a, codepoint2str(a)) for a in row] for row in rows_as_ints]

# Joining columns into rows and printing rows one in a separate line
print('\n'.join([''.join(row) for row in rows_as_strings]))
