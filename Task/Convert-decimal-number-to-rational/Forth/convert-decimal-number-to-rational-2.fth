: RealToRational                       ( f n1 -- n2 n3)
  0 dup rot max-n s>f fswap fdup f0< >r
  fabs fdup ftrunc f>s 1+ swap         ( den num lim real R: neg F: best real)
                                       \ helps set integer bounds around target
  1+ 1 ?do                             \ search through possible denominators
    dup i * over 1- i * ?do            \ search within integer limits bounding the real
      fover fover i s>f j s>f f/ f- fabs fdup frot f<
      if nip nip j i rot fswap frot then fdrop
    loop                               \ e.g. for 3.1419e search only between 3 and 4
  loop

  fdrop fdrop drop r> if negate then swap
;
