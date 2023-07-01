# syntax: TAWK -f KEYBOARD_INPUT_KEYPRESS_CHECK.AWK
BEGIN {
    arr["\b"] = "BACKSPACE"
    arr["\t"] = "TAB"
    arr["\x0D"] = "ENTER"
    printf("%s  Press any key; ESC to exit\n",ctime())
    while (1) {
      nkeys++
      key = getkey()
      if (key in arr) { key = arr[key] }
      space = ((length(key) > 1 && nkeys > 1) || length(p_key) > 1) ? " " : ""
      keys = keys space key
      if (key == "ESC") { break }
      p_key = key
    }
    printf("%s  %d keys were pressed\n",ctime(),nkeys)
    printf("%s\n",keys)
    exit(0)
}
