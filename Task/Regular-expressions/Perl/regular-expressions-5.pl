# add the following just after the last / for additional control
# g = globally (match as many as possible)
# i = case-insensitive
# s = treat all of $string as a single line (in case you have line breaks in the content)
# m = multi-line (the expression is run on each line individually)

$string =~ s/i/u/ig; # would change "I am a string" into "u am a strung"
