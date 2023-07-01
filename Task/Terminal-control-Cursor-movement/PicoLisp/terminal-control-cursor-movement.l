(call 'tput "cub1")                                # one position to the left
(call 'tput "cuf1")                                # one position to the right
(call 'tput "cuu1")                                # up one line
(call 'tput "cud1")                                # down one line
(call 'tput "cr")                                  # beginning of the line
(call 'tput "hpa" (sys "COLUMNS"))                 # end of the line
(call 'tput "home")                                # top left corner
(call 'tput "cup" (sys "LINES") (sys "COLUMNS"))   # bottom right corner
