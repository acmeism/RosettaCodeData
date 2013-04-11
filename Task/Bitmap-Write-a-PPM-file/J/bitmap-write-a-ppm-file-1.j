require 'files'

NB. ($x) is height, width, colors per pixel
writeppm=:dyad define
  header=. 'P6',LF,(":1 0{$x),LF,'255',LF
  (header,,x{a.) fwrite y
)
