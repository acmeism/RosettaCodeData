require "lfs"

local out
if lfs.attributes('/dev/tape') then
    out = '/dev/tape'
else
    out = 'tape.file'
end
file = io.open(out, 'w')
file:write('Hello world')
io.close(file)
