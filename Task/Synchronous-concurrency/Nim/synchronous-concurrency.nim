var msgs: Channel[string]
var count: Channel[int]

const FILE = "input.txt"

proc read() {.thread.} =
  for line in FILE.lines:
    msgs.send(line)
  msgs.send("")
  echo count.recv()
  count.close()

proc print() {.thread.} =
  var n = 0
  while true:
    var msg = msgs.recv()
    if msg.len == 0:
      break
    echo msg
    n += 1
  msgs.close()
  count.send(n)

var reader_thread = Thread[void]()
var printer_thread = Thread[void]()

msgs.open()
count.open()
createThread(reader_thread, read)
createThread(printer_thread, print)
joinThreads(reader_thread, printer_thread)
