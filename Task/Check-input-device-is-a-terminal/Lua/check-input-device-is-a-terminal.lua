local posix = require"posix"
print(
 posix.unistd.isatty(posix.stdio.fileno(io.stdin))
 and "stdin is a terminal"
 or "stdin is not a terminal"
)
