import bitmap
import osproc
import ppm_read
import streams

# Launch Netpbm "jpegtopnm".
# Input is taken from "input.jpeg" and result sent to stdout.
let p = startProcess("jpegtopnm", args = ["input.jpeg"], options = {poUsePath})
let stream = FileStream(p.outputStream())
let image = stream.readPPM()
echo image.w, " ", image.h
p.close()
