require'web/gethttp'

unixdict=:verb define
  if. _1 -: fread 'unixdict.txt' do.
    (gethttp 'http://www.puzzlers.org/pub/wordlists/unixdict.txt') fwrite 'unixdict.txt'
  end.
  fread 'unixdict.txt'
)

words=:verb define
  (#~ 1 - 0&e.@e.&'abcdefghijklmnopqrstuvwxyz'@>) (#~ [: (2&< * 10&>:) #@>) <;._2 unixdict''
)

dirs=: 10#.0 0-.~>,{,~<i:1
lims=: _10+,"2 +/&>/"1 (0~:i:4)#>,{,~<<"1]1 10 1 +i."0]10*i:_1
dnms=: ;:'nw north ne west east sw south se'

genpuz=:verb define
  words=. words''
  fill=. 'ROSETTACODE'
  grid=. ,10 10$' '
  inds=. ,i.10 10
  patience=. -:#words
  key=. i.0 0
  inuse=. i.0 2
  while. (26>#key)+.0<cap=. (+/' '=grid)-#fill do.
    word=. >({~ ?@#) words
    dir=. ?@#dirs
    offs=. (inds#~(#word)<:inds{dir{lims)+/(i.#word)*/dir{dirs
    cool=. ' '=offs{grid
    sel=. */"1 cool+.(offs{grid)="1 word
    offs=. (sel*cap>:+/"1 cool)#offs
    if. (#offs) do.
      off=. ({~ ?@#) offs
      loc=. ({.off),dir
      if. -. loc e. inuse do.
        inuse=. inuse,loc
        grid=. word off} grid
        patience=. patience+1
        key=. /:~ key,' ',(10{.word),(3":1+10 10#:{.off),' ',dir{::dnms
      end.
    else. NB. grr...
      if. 0 > patience=. patience-1 do.
        inuse=.i.0 2
        key=.i.0 0
        grid=. ,10 10$' '
        patience=. -:#words
      end.
    end.
  end.
  puz=. (_23{.":i.10),' ',1j1#"1(":i.10 1),.' ',.10 10$fill (I.grid=' ')} grid
  puz,' ',1 1}._1 _1}.":((</.~ <.) i.@# * 3%#)key
)
