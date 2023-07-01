import sys

if "UTF-8" in sys.stdout.encoding:
    print("△")
else:
    raise Exception("Terminal can't handle UTF-8")
