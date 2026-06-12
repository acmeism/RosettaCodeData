import algorithm, heapqueue, os, random, sequtils, strformat, strutils


proc sortFiles(filenames: seq[string]) =
  for filename in filenames:
    var lines = filename.readFile()
    lines.stripLineEnd()  # Ignore last line feed, if any.
    var sortedLines = sorted(lines.splitLines())
    echo &"""{filename} => {sortedLines.join(", ")}"""
    filename.writeFile(sortedLines.join("\n"))


proc mergeFiles(outfile: File; filenames: seq[string]) =
  var queue: HeapQueue[(string, File)]
  for filename in filenames:
    let f = open(fileName)
    queue.push (f.readLine(), f)
  while queue.len > 0:
    let (s, infile) = queue.pop()
    outfile.write s & '\n'
    if infile.endOfFile:
      infile.close()
    else:
      queue.push((infile.readLine(), infile))


when isMainModule:
  const WriteToFile = false   # Compile time switch.

  randomize()
  let nf = rand(2..4)   # Number of files.
  let lp = 3            # Lines per file.
  var filenames: seq[string]
  var lines = toSeq(1..nf*lp)
  lines.shuffle()

  for i in 1..nf:
    let filename = &"file{i}.txt"
    filenames.add filename
    let f = open(filename, fmWrite)
    for l in 1..lp:
      f.write &"Line {lines[^l]:2}\n"
    lines.setLen(lines.len - lp)
    f.close()

  echo &"sorting {nf * lp} lines split over {nf} files"
  sortFiles(filenames)

  when WriteToFile:
    let f = open("results.txt", fmWrite)
    mergeFiles(f, filenames)
    f.close()
  else:
    mergeFiles(stdout, filenames)

  for filename in filenames:
    removeFile(filename)
