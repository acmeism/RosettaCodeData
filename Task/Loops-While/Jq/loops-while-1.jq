# To avoid printing 0, test if the input is greater than 1
1024 | recurse( if . > 1 then ./2 | floor else empty end)
