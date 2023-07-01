import commands
stat, out = commands.getstatusoutput('ls')
if not stat:
    print out
