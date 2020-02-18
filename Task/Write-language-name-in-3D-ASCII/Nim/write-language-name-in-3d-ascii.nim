import strutils

const nim = """
 #    #   #####   #    #
 ##   #     #     ##  ##
 # #  #     #     # ## #
 #  # #     #     #    #
 #   ##     #     #    #
 #    #   #####   #    #
"""
let lines = nim.replace("#", "<<<").replace(" ", "   ").replace("< ", "<>").replace("<\n", "<>\n").splitLines
for i, line in lines:
  echo spaces(lines.len - i), line
