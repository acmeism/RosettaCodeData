infile = open('input.txt', 'r')
outfile = open('output.txt', 'w')
for line in infile:
   outfile.write(line)
outfile.close()
infile.close()
