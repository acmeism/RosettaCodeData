$results = `ls`;
# runs command and returns its STDOUT as a string

system("ls");
# runs command and returns its exit status; its STDOUT gets output to our STDOUT

echo `ls`;
# the same, but with back quotes

passthru("ls");
# like system() but binary-safe
