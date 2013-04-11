NB. converts the image to grayscale according to formula
NB. L = 0.2126*R + 0.7152*G + 0.0722*B
toGray=: [: <. +/ .*"1&0.2126 0.7152 0.0722

NB. converts grayscale image to the color image, with all channels equal
toColor=: 3 & $"0
