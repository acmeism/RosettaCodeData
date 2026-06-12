require 'socket'

# Ruby has no direct access to mkfifo(2). We use a shell script.
system '/bin/sh', '-c', <<EOF or abort
test -p in || mkfifo in || exit
test -p out || mkfifo out || exit
EOF

# Forks a process to open _path_. Returns a _socket_ to receive the open
# IO object (by UNIXSocket#recv_io).
def open_sesame(path, mode)
  reader, writer = UNIXSocket.pair
  pid = fork do
    begin
      reader.close
      file = File.open(path, mode)
      writer.send_io file
    ensure
      exit!
    end
  end
  Process.detach pid
  writer.close
  return reader
end

insock = open_sesame("in", "rb")
outsock = open_sesame("out", "w")
inpipe, outpipe = nil
count = 0
readers = [insock, outsock]
writers = []
loop do
  selection = select(readers, writers)
  selection[0].each do |reader|
    case reader
    when insock
      inpipe = insock.recv_io
      puts "-- Opened 'in' pipe."
      insock.close
      readers.delete insock
      readers.push inpipe
    when outsock
      outpipe = outsock.recv_io
      puts "-- Opened 'out' pipe."
      outsock.close
      readers.delete outsock
      writers.push outpipe
    when inpipe
      count += (inpipe.read_nonblock(4096).size rescue 0)
    end
  end
  selection[1].each do |writer|
    case writer
    when outpipe
      outpipe.puts count
      puts "-- Counted #{count} bytes."
      exit
    end
  end
end
