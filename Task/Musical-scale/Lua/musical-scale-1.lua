c = string.char
midi = "MThd" .. c(0,0,0,6,0,0,0,1,0,96) -- header
midi = midi .. "MTrk" .. c(0,0,0,8*8+4) -- track
for _,note in ipairs{60,62,64,65,67,69,71,72} do
  midi = midi .. c(0, 0x90, note, 0x40, 0x60, 0x80, note, 0) -- notes
end
midi = midi .. c(0, 0xFF, 0x2F, 0) -- end

file = io.open("scale.mid", "wb")
file:write(midi)
file:close()

-- (optional:  hex dump to screen)
midi:gsub(".", function(c) io.write(string.format("%02X ", string.byte(c))) end)
