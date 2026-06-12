from terminal import ansiResetCode

const
  RED =    "\e[38;2;255;0;0m"
  ORANGE = "\e[38;2;255;128;0m"
  YELLOW = "\e[38;2;255;255;0m"
  GREEN =  "\e[38;2;0;255;0m"
  BLUE =   "\e[38;2;0;0;255m"
  INDIGO = "\e[38;2;75;0;130m"
  VIOLET = "\e[38;2;128;0;255m"

  COLORS = [RED, ORANGE, YELLOW, GREEN, BLUE, INDIGO, VIOLET]
  RAINBOW = "RAINBOW"

for i in 0..<7:
  stdout.write(COLORS[i] & RAINBOW[i])
stdout.write(ansiResetCode)
