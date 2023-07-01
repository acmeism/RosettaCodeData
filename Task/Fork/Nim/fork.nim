import posix

var pid = fork()
if pid < 0:
    echo "Error forking a child"
elif pid > 0:
    echo "This is the parent process and its child has id ", pid, '.'
    # Further parent stuff.
else:
    echo "This is the child process."
    # Further child stuff.
