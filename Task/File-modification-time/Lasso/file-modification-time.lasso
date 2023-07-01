local(f) = file('input.txt')
handle => { #f->close }
#f->modificationDate->format('%-D %r')
// result: 12/2/2010 11:04:15 PM
