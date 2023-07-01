// delete file
local(f = file('input.txt'))
#f->delete

// delete directory
// directory must be empty before it can be successfully deleted. A failure is generated if the operation fails.
local(d = dir('docs'))
#d->delete

// delete file in root file system (requires permissions at user OS level)
local(f = file('//input.txt'))
#f->delete

// delete directory in root file system (requires permissions at user OS level)
// directory must be empty before it can be successfully deleted. A failure is generated if the operation fails.
local(d = file('//docs'))
#d->delete
