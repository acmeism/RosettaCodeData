// local to current directory
local(f = file('input.txt'))
handle => { #f->close }
#f->size

// file at file system root
local(f = file('//input.txt'))
handle => { #f->close }
#f->size
