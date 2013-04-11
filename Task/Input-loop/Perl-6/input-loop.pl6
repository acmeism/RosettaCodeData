my $handle = open "filename.txt"; # $handle could be $*IN to read from standard input

for $handle.lines -> $line {  # iterates the lines of the $handle

    # line endings are automatically stripped

    for $line.words -> $word { # iterates the words of the line
           # are considered words groups of non-whitespace characters
    }
}
