require'web/gethttp'

setstats=:dyad define
  'plen slen limit'=: x
  txt=. gethttp y
  letters=. (tolower~:toupper)txt
  NB. apostrophes have letters on both sides
  apostrophes=. (_1 |.!.0 letters)*(1 |.!.0 letters)*''''=txt
  parsed=. <;._1 ' ',deb ' ' (I.-.letters+apostrophes)} tolower txt
  words=: ~.parsed
  corpus=: words i.parsed
  prefixes=: ~.plen]\corpus
  suffixes=: ~.slen]\corpus
  ngrams=. (plen+slen)]\corpus
  pairs=. (prefixes i. plen{."1 ngrams),. suffixes i. plen}."1 ngrams
  stats=: (#/.~pairs) (<"1~.pairs)} (prefixes ,&# suffixes)$0
  weights=: +/\"1 stats
  totals=: (+/"1 stats),0
  i.0 0
)

genphrase=:3 :0
  pren=. #prefixes
  sufn=. #suffixes
  phrase=. (?pren) { prefixes
  while. limit > #phrase do.
    p=. prefixes i. (-plen) {. phrase
    t=. p { totals
    if. 0=t do. break.end. NB. no valid matching suffix
    s=. (p { weights) I. ?t
    phrase=. phrase, s { suffixes
  end.
  ;:inv phrase { words
)
