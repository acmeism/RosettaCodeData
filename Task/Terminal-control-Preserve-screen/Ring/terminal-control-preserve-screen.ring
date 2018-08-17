# Project : Terminal control/Preserve screen

load "stdlib.ring"
see char(33) + "[?1049h\" + char(33) + "[H" + nl
see "Alternate screen buffer" + nl
for i = 5 to 1 step -1
     see "going back in " + i + "..." + nl
     sleep(1)
next
see char(33) + "[?1049l" + nl
