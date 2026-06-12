# Make the pipes by calling a subprocess...
exec sh -c {test -p in || mkfifo in || exit 1;test -p out || exec mkfifo out}

# How many bytes have we seen so far?
set count 0

# Read side; uses standard fileevent mechanism (select() under the covers)
set in [open in {RDONLY NONBLOCK}]
fconfigure $in -translation binary
fileevent $in readable consume
proc consume {} {
    global count in
    # Reads only 4kB at a time
    set data [read $in 4096]
    incr count [string length $data]
}

# Writer side; relies on open() throwing ENXIO on non-blocking open of write side
proc reportEveryHalfSecond {} {
    global count
    catch {
	set out [open out {WRONLY NONBLOCK}]
	puts $out $count
	close $out
    }
    # Polling nastiness!
    after 500 reportEveryHalfSecond
}
reportEveryHalfSecond

# Run the event loop until done
vwait forever
