import sys

for line in sys.stdin:
    print(sum(int(i) for i in line.split()))
