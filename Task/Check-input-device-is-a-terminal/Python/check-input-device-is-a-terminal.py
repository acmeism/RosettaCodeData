from sys import stdin
if stdin.isatty():
    print("Input comes from tty.")
else:
    print("Input doesn't come from tty.")
