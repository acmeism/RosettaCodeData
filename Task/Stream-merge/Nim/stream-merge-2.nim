import heapqueue, os, sequtils, streams

type
    Source = tuple[stream: Stream; line: string]
    SourceHeap = HeapQueue[Source]


# Comparison of sources. Needed for the heap to sort the sources by line contents.
proc `<`(a, b: Source): bool = a.line < b.line


proc add(heap: var SourceHeap; stream: Stream) =
  ## Add a stream to the heap.
  if stream.atEnd:
    stream.close()
  else:
    heap.push((stream, stream.readLine()))


proc merge(inStreams: seq[Stream]; outStream: Stream) =
  ## Merge the input streams into an output stream.

  # Initialize the heap.
  var heap: SourceHeap
  for stream in inStreams:
    heap.add(stream)

  # Merging loop.
  while heap.len > 0:
    let (stream, line) = heap.pop()
    outStream.writeLine line
    heap.add(stream)


when isMainModule:

  const
    Data = ["Line 001\nLine 008\nLine 017\n",
            "Line 019\nLine 033\nLine 044\nLine 055\n",
            "Line 019\nLine 029\nLine 039\n",
            "Line 023\nLine 030\n"]
    Filenames = ["file1.txt", "file2.txt", "file3.txt", "file4.txt"]

  # Create files.
  for i, name in Filenames:
    writeFile(name, Data[i])

  # Create input and output streams.
  let inStreams = Filenames.mapIt(Stream(newFileStream(it)))
  let outStream = Stream(newFileStream(stdout))

  # Merge the streams.
  merge(inStreams, outStream)

  # Clean-up: delete the files.
  for name in Filenames:
    removeFile(name)
