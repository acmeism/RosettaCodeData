bs=: 2
chunkFasta=: {{
  r=. EMPTY
  bad=. a.-.a.{~;48 65 97(+i.)each 10 26 26
  dir=. x,'/'
  off=. 0
  siz=. fsize y
  block=. dest=. ''
  while. off < siz do.
    block=. block,fread y;off([, [ -~ siz<.+)bs
    off=. off+bs
    while. LF e. block do.
      line=. LF taketo block
      select. {.line
        case. ';' do.
        case. '>' do.
          start=. }.line-.CR
          r=.r,(head=. name,'.head');<name=. dir,start -. bad
          start fwrite head
          '' fwrite name
        case. do.
          (line-.bad) fappend name
      end.
      block=. LF takeafter block
    end.
  end.
  r
}}
