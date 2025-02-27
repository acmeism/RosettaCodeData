require "io"

lp = io.open("/dev/lp0", 'w')

io.output(lp)
io.write("Hello World\n")
io.close(lp)
