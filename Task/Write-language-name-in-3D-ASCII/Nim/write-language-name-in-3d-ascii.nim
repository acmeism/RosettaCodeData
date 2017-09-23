import strutils

const nim = """
 #    #   #####   #    #
 ##   #     #     ##  ##
 # #  #     #     # ## #
 #  # #     #     #    #
 #   ##     #     #    #
 #    #   #####   #    #"""

let lines = nim.replace("#", "<<<").replace(" ", "X").replace("X", "   ").replace("\n", " Y").replace("< ", "<>").split('Y')
for i, line in lines:
  echo spaces((lines.len - i) * 3), line
