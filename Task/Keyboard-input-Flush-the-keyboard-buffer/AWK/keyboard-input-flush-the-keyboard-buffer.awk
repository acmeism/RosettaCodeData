# syntax: TAWK -f KEYBOARD_INPUT_FLUSH_THE_KEYBOARD_BUFFER.AWK
BEGIN {
    while (kbhit()) {
      getkey()
    }
    exit(0)
}
