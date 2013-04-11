import sys
try:
    with open('input.txt') as infile:
        with open('output.txt', 'w') as outfile:
            for line in infile:
                outfile.write(line)
except IOError:
    print >> sys.stderr, "Some I/O Error occurred"
    sys.exit(1)
