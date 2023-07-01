import streams,strutils
let
  stream1 = newFileStream("file1")
  stream2 = newFileStream("file2")
while not stream1.atEnd and not stream2.atEnd:
  echo (if stream1.peekLine.parseInt > stream2.peekLine.parseInt: stream2.readLine else: stream1.readLine)

for line in stream1.lines:
  echo line
for line in stream2.lines:
  echo line
