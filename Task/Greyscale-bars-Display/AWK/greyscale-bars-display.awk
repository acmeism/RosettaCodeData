BEGIN {
  nrcolors = 8
  direction = 1

  for (quarter=0; quarter<4; quarter++) {
    for (height=0; height<5; height++) {
      for (width=0; width<nrcolors; width++) {
        # gradient goes white-to-black or black-to-white depending on direction
        if (direction % 2)
          color = width * (255 / (nrcolors-1))
        else
          color = 255 - width * (255 / (nrcolors-1))

        # print (ANSI) RGB greysacle color and amount of spaces
        printf("\033[48;2;%d;%d;%dm%*s", color, color, color, 64 / nrcolors, " ")
      }
      # reset color and print newline
      printf("\033[0m\n")
    }

    # 8, 16, 32, 64 colors and alternating direction of gradient
    nrcolors *= 2
    direction++
  }
}
