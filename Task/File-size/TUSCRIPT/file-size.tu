$$ MODE TUSCRIPT
-- size of file input.txt
file="input.txt"
ERROR/STOP OPEN (file,READ,-std-)
file_size=BYTES ("input.txt")
ERROR/STOP CLOSE (file)

-- size of file x:/input.txt
ERROR/STOP OPEN (file,READ,x)
file_size=BYTES (file)
ERROR/STOP CLOSE (file)
