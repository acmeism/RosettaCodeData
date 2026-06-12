import algorithm, strutils

proc reverseLines(infile, outfile: File) =
  let lines = infile.readAll().splitLines(keepEol = true)
  outfile.write reversed(lines).join("")

when isMainModule:
  let infile = open("reverse_file_lines.txt")
  echo ">>>>> Input file:"
  stdout.write infile.readAll()
  infile.setFilePos(0)
  echo ">>>>>"
  echo '\n'
  echo ">>>>> Output file:"
  reverseLines(infile, stdout)
  echo ">>>>>"
