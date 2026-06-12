python -c '
import sys
for ln in sys.stdin:
    if "a" in ln and ln.find("a") < ln.find("b") < ln.find("c"):
        print(ln.rstrip())
' < unixdict.txt
