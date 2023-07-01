var f = open("/dev/urandom")
var r: int32
discard f.readBuffer(addr r, 4)
close(f)
echo r
