tput cub1                  # one position to the left
tput cuf1                  # one position to the right
tput cuu1                  # up one line
tput cud1                  # down one line
tput cr                    # beginning of line
tput home                  # top left corner

# For line ends and bottom, we need to determine size
# of terminal
WIDTH=`tput cols`
HEIGHT=`tput lines`

tput hpa $WIDTH            # end of line
tput cup $HEIGHT $WIDTH    # bottom right corner
