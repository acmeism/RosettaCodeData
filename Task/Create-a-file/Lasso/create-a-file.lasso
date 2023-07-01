// create file
local(f) = file
handle => { #f->close }
#f->openWriteOnly('output.txt')

// make directory, just like a file
local(d = dir('docs'))
#d->create

// create file in root file system (requires permissions at user OS level)
local(f) = file
handle => { #f->close }
#f->openWriteOnly('//output.txt')

// create directory in root file system (requires permissions at user OS level)
local(d = dir('//docs'))
#d->create
