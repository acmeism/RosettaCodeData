// move file
local(f = file('input.txt'))
#f->moveTo('output.txt')
#f->close

// move directory, just like a file
local(d = dir('docs'))
#d->moveTo('mydocs')

// move file in root file system (requires permissions at user OS level)
local(f = file('//input.txt'))
#f->moveTo('//output.txt')
#f->close

// move directory in root file system (requires permissions at user OS level)
local(d = file('//docs'))
#d->moveTo('//mydocs')
