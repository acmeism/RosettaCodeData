BEGIN {
  nrcolors = 8

  for (height=0; height<20; height++) {
    for (width=0; width<nrcolors; width++) {
      # print (ANSI) basic color and amount of spaces
      printf("\033[%dm%*s", width + 40, 64 / nrcolors, " ")
    }

    # reset color and print newline
    printf("\033[0m\n")
  }
}
