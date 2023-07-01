randLineBig=:3 :0
  file=. boxopen y
  r=. ''
  n=. 1
  size=. fsize file
  blocksize=. 1e7
  buffer=. ''
  for_block. |: blocksize -~/\@(] <. [ * 0 1 +/i.@>.@%~) size do.
    buffer=. buffer, fread file,<block
    linends=. LF = buffer
    lines=. linends <;.2 buffer
    buffer=. buffer }.~ {: 1+I.linends
    pick=. (0 ?@$~ #lines) < % n+i.#lines
    if. 1 e. pick do.
      r=. ({:I.pick) {:: lines
    end.
    n=. n+#lines
  end.
  r
)
