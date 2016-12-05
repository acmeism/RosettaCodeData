var lp = open("/dev/lp0", fmWrite)
lp.writeln "Hello World"
lp.close()
