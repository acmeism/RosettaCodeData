INT pages=100, lines=25, characters=80;
FILE bookf; FLEX[pages]FLEX[lines]FLEX[characters]CHAR book;
associate(bookf, book);

# following putf inserts the string "    Line 4 indented 5" on page 3 #
putf(bookf, $3p"Page 3"4l5x"Line 4 indented 5"$)
