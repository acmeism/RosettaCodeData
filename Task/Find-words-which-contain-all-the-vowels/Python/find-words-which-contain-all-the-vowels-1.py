with open('unixdict.txt') as f:
  while (line := f.readline().strip()):
    if (len(line) > 10 and all(
        line.count(c) == 1 for c in 'aeiou')):
      print(line)
