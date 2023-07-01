from sys import stdout
if stdout.isatty():
    print 'The output device is a teletype. Or something like a teletype.'
else:
    print 'The output device isn\'t like a teletype.'
