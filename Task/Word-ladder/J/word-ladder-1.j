extend=: {{
  j=. {:y
  l=. <:{:$m
  <y,"1 0 I.l=m+/ .="1 j{m
}}

wlad=: {{
  l=. #x assert. l=#y
  words=. >(#~ l=#@>) cutLF fread 'unixdict.txt'
  ix=. ,:words i.x assert. ix<#words
  iy=. ,:words i.y assert. iy<#words
  while. -. 1 e. ix e.&, iy do.
    if. 0 e. ix,&# iy do. EMPTY return. end.
    ix=. ; words extend"1 ix
    if. -. 1 e. ix e.&, iy do.
      iy=. ; words extend"1 iy
    end.
  end.
  iy=. |."1 iy
  r=. ix,&,iy
  for_jk.(ix,&#iy)#:I.,ix +./@e."1/ iy do.
    ixj=. ({.jk){ix
    iyk=. ({:jk){iy
    for_c. ixj ([-.-.) iyk do.
      path=. (ixj{.~ixj i.c) , iyk}.~ iyk i.c
      if. path <&# r do. r=. path end.
    end.
  end.
  }.,' ',.r{words
}}
