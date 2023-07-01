[
    "input.txt" binary <file-reader> &dispose
    "output.txt" binary <file-writer> stream-copy
] with-destructors
