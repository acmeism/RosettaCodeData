import strformat, strutils

const Data = """
A    bbbbB0001+d2345
AA   bbbBB0002+1d345
AAA  bbBBB0003+12d45
AAAA bBBBB0001-123d5
AAAAABBBBB0002-1234d
"""

"in.txt".writeFile(Data)

let outfile = "out.txt".open(fmWrite)
for line in "in.txt".lines:
  let a = line.substr(0, 4)
  let n = parseInt(line[14] & line.substr(10, 13))
  let s = &"{a}{n:5}XXXXX\n"
  stdout.write s
  outfile.write s
outfile.close()
