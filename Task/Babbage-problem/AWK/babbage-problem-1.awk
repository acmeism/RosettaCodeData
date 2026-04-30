# A comment starts with a "#" and are ignored by the machine.  They can be on a
# line by themselves or at the end of an executable line.
#
# A program consists of multiple lines or statements.  This program tests
# positive integers starting at 1 and terminates when one is found whose square
# ends in 269696.
#
# The next line shows how to run the program.
# syntax: GAWK -f BABBAGE_PROBLEM.AWK
#
BEGIN { # start of program
# this declares a variable named "n" and assigns it a value of zero
    n = 0
# do what's inside the "{}" until n times n ends in 269696
    do {
      n = n + 1 # add 1 to n
    } while (n*n !~ /269696$/)
# print the answer
    print("The smallest number whose square ends in 269696 is " n)
    print("Its square is " n*n)
# terminate program
    exit(0)
} # end of program
