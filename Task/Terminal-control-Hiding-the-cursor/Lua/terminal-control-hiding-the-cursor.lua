local csi = "\027["
local hide, show = csi .. "?25l", csi .. "?25h"
io.write("Here's the cursor: ", show) io.read()
io.write("Aaand its gone", hide) io.read()
io.write(show)
print"TADA!"
