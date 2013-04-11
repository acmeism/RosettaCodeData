import collections, sys

def filecharcount(openfile):
    return sorted(collections.Counter(c for l in openfile for c in l).items())

f = open(sys.argv[1])
print(filecharcount(f))
