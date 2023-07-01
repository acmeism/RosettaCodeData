FILE tape;
INT errno = open(tape, "/dev/tape1", stand out channel)
make conv(tape, ebcdic conv);
FOR record DO getf(tape, ( ~ )) OD; ~ # etc ... #
