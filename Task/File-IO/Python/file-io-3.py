import sys
try:
    infile = open('input.txt', 'r')
except IOError:
    print >> sys.stderr, "Unable to open input.txt for input"
    sys.exit(1)
try:
    outfile = open('output.txt', 'w')
except IOError:
    print >> sys.stderr, "Unable to open output.txt for output"
    sys.exit(1)
try:  # for finally
    try: # for I/O
        for line in infile:
            outfile.write(line)
    except IOError, e:
        print >> sys.stderr, "Some I/O Error occurred (reading from input.txt or writing to output.txt)"
finally:
    infile.close()
    outfile.close()
