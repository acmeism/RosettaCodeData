NB. generate a frequency dictionary from a reference string
aekDict=:verb define
  d=. ~.y            NB. dictionary lists unique characters
  o=. /:d            NB. in canonical order
  f=. (#/.~%&x:#)y   NB. and their relative frequencies
  (o{d);o{f
)

NB. encode a string against a reference dict
aekEnc=:verb define
  NB. use string to generate a dict if none provided
  (aekDict y) aekEnc y
:
  'u F'=.x                   NB. unpack dictionary
  b=. x:#y                   NB. numeric base
  f=. b*F                    NB. absolute frequencies
  i=. u i.y                  NB. character indices
  c=. +/\0,}:f               NB. cumulative frequencies
  L=. b #. (i{c)**/\1,}:i{f  NB. lower bound
  p=. */i{f                  NB. product of character frequencies
  e=. x:<.10^.p              NB. number of decimal positions to drop
  e,~<.(L+p)%10^e
)

aekDec=:adverb define
:
  'u F'=. x                  NB. unpack dictionary
  f=. m*F                    NB. frequencies of characters
  c=.+/\0,}:f                NB. cumulative frequencies
  C=.<:}.c,m                 NB. id lookup table
  N=. (* 10&^)/y             NB. remainder being decoded
  r=. ''                     NB. result of decode
  for_d. m^x:i.-m do.        NB. positional values
   id=. <.N%d                NB. character id
   i=.C I.id                 NB. character index
   N=.<.(N -(i{c)*d)%i{f     NB. corrected remainder
   r=.r,u{~i                 NB. accumulated result
  end.
)

NB. task demo utility:
aek=:verb define
  dict=. aekDict y
  echo 'Dictionary:'
  echo ' ',.(0{::dict),.' ',.":,.1{::dict
  echo 'Length:'
  echo ' ',":#y
  echo 'Encoded:'
  echo ' ',":dict aekEnc y
  echo 'Decoded:'
  echo ' ',":dict (#y) aekDec aekEnc y
)
