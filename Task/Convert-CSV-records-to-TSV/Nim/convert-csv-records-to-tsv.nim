import std/[os, strutils]


proc csvToTsv(str: string): tuple[csv, tsv: string] =
  var p = str.split(',')
  for i in 0..p.high:
    if p[i].count('"') > 1:
      p[i] = p[i].strip(chars = {' ', '"'}).replace("\"\"", "\"")
    elif p[i] == "\"":
      p[i] = ""
  let replacements = [("\\", "\\\\"), ("\t", "\\t"), ("\0", "\\0"), ("\n", "\\n"), ("\r", "\\r")]
  result.csv = str.multiReplace(replacements)
  result.tsv = p.join("<TAB>").multiReplace(replacements)


const TestFile = "test.tmp"
let file = open(TestFile, fmWrite)
let str = ["""a,"b"""", """"a","b""c"""", "", ",a", """a,"""",
           """ a , "b"""", """"12",34""", "a\tb, TAB", "a\\tb",
           "a\\n\\rb", "a\0b, NUL", "a\rb, RETURN", "a\\b"]
file.write str.join("\n")
file.close()

for testString in lines(TestFile):
  let (csv, tsv) = testString.csvToTsv()
  echo csv.align(12), " => ", tsv

os.removeFile TestFile
