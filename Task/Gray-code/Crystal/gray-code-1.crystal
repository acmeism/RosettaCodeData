def gray_encode(bin)
  bin ^ (bin >> 1)
end

def gray_decode(gray)
  bin = gray
  while gray > 0
    gray >>= 1
    bin ^= gray
  end
  bin
end
