require random.fs
: prngimage
outfile-id >r
s" prngimage.pbm" w/o create-file throw to outfile-id
s\" P1\n500 500\n" type
500 0 do
  500 0 do
    2 random 48 + emit
  loop  #lf emit
loop
outfile-id close-file throw
r> to outfile-id ;

prngimage
