-- prep: convert given sample text to fixed length "infile.dat"
local sample = [[
Line 1...1.........2.........3.........4.........5.........6.........7.........8
Line 2
Line 3
Line 4

Line 6
Line 7
     Indented line 8............................................................
Line 9                                                                 RT MARGIN]]
local txtfile = io.open("sample.txt", "w")
txtfile:write(sample)
txtfile:close()
os.execute("dd if=sample.txt of=infile.dat cbs=80 conv=block > /dev/null 2>&1")

-- task: convert fixed length "infile.dat" to fixed length "outfile.dat" (reversed lines)
local infile = io.open("infile.dat", "rb")
local outfile = io.open("outfile.dat", "wb")
while true do
  local line = infile:read(80)
  if not line then break end
  outfile:write(string.reverse(line))
end
infile:close()
outfile:close()

-- output:
os.execute("dd if=outfile.dat cbs=80 conv=unblock")
