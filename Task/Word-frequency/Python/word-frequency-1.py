import collections
import re
import string
import sys

def main():
  counter = collections.Counter(re.findall(r"\w+",open(sys.argv[1]).read().lower()))
  print counter.most_common(int(sys.argv[2]))

if __name__ == "__main__":
  main()
