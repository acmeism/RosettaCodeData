ltrfreq=: 3 : 0
  letters=. u: 65 + i.26  NB. upper case letters
  <: #/.~ letters (, -. -.~) toupper fread y
)
