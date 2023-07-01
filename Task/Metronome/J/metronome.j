MET=: _ _&$: :(4 : 0)

  'BEL BS LF CR'=. 7 8 10 13 { a.
  '`print stime delay'=. 1!:2&4`(6!:1)`(6!:3)
  ticker=. 2 2$'\  /'
  'small large'=. (BEL,2#BS) ; 5#BS
  clrln=. CR,(79#' '),CR

  x=. 2 ({.,) x
  y=. _1 |.&.> 2 ({.,) y
  'i j'=. 0
  print 'bpb \  bpm \ ' , 2#BS
  delay 1

  x=. ({. , ('ti t'=. stime'') + {:) x
  while. x *./@:> i,t do.

    'bpb bpm'=. {.@> y=. 1 |.&.> y
    dl=. 60 % bpm

    print clrln,(":bpb),' ',(ticker {~ 2 | i=. >: i),' ',(":bpm),' '

    for. i. bpb do.
      print small ,~ ticker {~ 2 | j=. >: j
      delay 0 >. (t=. t + dl) - stime ''
    end.

  end.

  print clrln
  i , j , t - ti

)


NB. Basic tacit version; this is probably considered bad coding style. At least I removed the "magic constants". Sort of.
NB. The above version is by far superior.
'BEL BS LF'=: 7 8 10 { a.
'`print delay'=: 1!:2&4`(6!:3)
met=: _&$: :((] ({:@] [ LF print@[ (-.@{.@] [ delay@[ print@] (BEL,2#BS) , (2 2$'\  /') {~ {.@])^:({:@])) 1 , <.@%) 60&% [ print@('\ '"_))
