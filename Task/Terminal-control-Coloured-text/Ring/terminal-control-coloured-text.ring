# Project : Terminal control/Coloured text

load "consolecolors.ring"

forecolors = [CC_FG_BLACK,CC_FG_RED,CC_FG_GREEN,CC_FG_YELLOW,
                   CC_FG_BLUE,CC_FG_MAGENTA,CC_FG_CYAN,CC_FG_GRAY,CC_BG_WHITE]

for n = 1 to len(forecolors)
     forecolor = forecolors[n]
     cc_print(forecolor | CC_BG_WHITE, "Rosetta Code" + nl)
next
