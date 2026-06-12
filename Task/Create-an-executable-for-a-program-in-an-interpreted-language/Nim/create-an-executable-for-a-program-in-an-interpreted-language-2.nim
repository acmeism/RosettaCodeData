# Using the '--eval" option.

import std/[os, strutils]

const Program = """echo "Hello World!""""

# As the program is provided in the command line, there is no need
# to create a temporary file.

# Lauch "nim" to execute the program.
# "--hints:off" suppresses the hint messages.
discard execShellCmd("""nim --hints:off --eval:'$#'""" % Program)
