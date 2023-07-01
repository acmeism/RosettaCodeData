var lp = open("/dev/lp0", fmWrite)
lp.writeLine "Hello World"
lp.close()
