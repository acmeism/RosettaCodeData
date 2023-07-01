# Lexical variables

 $_                  # implicit variable lexically scoped to the current block
 $!                  # current Exception object
 $/                  # last match
 $0, $1, $2...       # captured values from match: $/[0], $/[1], $/[2] ...

# Compile-time variables

$?PACKAGE            # current package
$?CLASS              # current class
$?MODULE             # current module
$?ROLE               # current role
$?DISTRIBUTION       # which OS distribution am I compiling under
$?FILE               # current filename of source file
$?LINE               # current line number in source file
&?ROUTINE            # current sub or method (itself)
&?BLOCK              # current block (itself)

# Dynamic variables

$*USAGE              # value of the auto-generated USAGE message
$*PROGRAM-NAME       # path to the current executable
$*PROGRAM            # location (in the form of an IO::Path object) of the Raku program being executed
@*ARGS               # command-line arguments
$*ARGFILES           # the magic command-line input handle
$*CWD                # current working directory
$*DISTRO             # which OS distribution am I running under
%*ENV                # system environment variables
$*ERR                # standard error handle
$*EXECUTABLE-NAME    # name of the Raku executable that is currently running
$*EXECUTABLE         # IO::Path absolute path of the Raku executable that is currently running
$*IN                 # standard input handle; is an IO object
$*KERNEL             # operating system running under
$*OUT                # standard output handle
$*RAKU               # Raku version running under
$*PID                # system process id
$*TZ                 # local time zone
$*USER               # system user id

# Run-time variables

$*COLLATION          # object that can be used to configure Unicode collation levels
$*TOLERANCE          # used by the =~= operator to decide if two values are approximately equal
$*DEFAULT-READ-ELEMS # affects the number of bytes read by default by IO::Handle.read
