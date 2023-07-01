import strutils

const nim = """
            #    #   #####   #    #
            ##   #     #     ##  ##
            # #  #     #     # ## #
            #  # #     #     #    #
            #   ##     #     #    #
            #    #   #####   #    #
            """
let lines = nim.dedent.multiReplace(("#", "<<<"), (" ", "   "), ("< ", "<>"), ("<\n", "<>\n")).splitLines
for i, line in lines:
  echo spaces(lines.len - i), line
