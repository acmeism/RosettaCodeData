my @results = qx(ls);  # run command and return STDOUT as a string

my @results = `ls`;    # same, alternative syntax

system "ls";           # run command and return exit status; STDOUT of command goes program STDOUT

print `ls`;            # same, but with back quotes

exec "ls";             # replace current process with another
