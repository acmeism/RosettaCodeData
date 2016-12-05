import strutils

const nim = """
 #    #   #####   #    #   ####    ####   ####
 ##   #     #     ##  ##   #   #  #    #  #   #
 # #  #     #     # ## #   #   #  #    #  #    #
 #  # #     #     #    #   ####   #    #  #    #
 #   ##     #     #    #   #  #   #    #  #   #
 #    #   #####   #    #   #   #   ####   ####"""

let lines = nim.replace("#", "<<<").replace(" ", "X").replace("X", "   ").replace("\n", " Y").replace("< ", "<>").split('Y')
for i, l in lines:
  echo repeatChar((lines.len - i) * 3), l
