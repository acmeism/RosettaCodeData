require 'files'    NB. define fread
ltrfreq=: 3 : 0
  letters=. u: (u:inv'A') + i.26  NB. upper case letters
  <: #/.~ (toupper fread y) (,~ -. -.) letters
)
