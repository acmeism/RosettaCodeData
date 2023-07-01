NB. delete any blank characters
delblk =. #~ ' '&~:
NB. rearrange
rot =. '00' ,~ 2&}. @: (2&|.)
NB. characters -> "digits"
dig =. a. {~ (a.i.'0')+i.10
dig =. dig,a. {~ (a.i.'A')+i.26
todig =. dig&i.
coded =. [: ". 'x' ,~ delblk @: ": @: todig

NB. calculate check sum
cs =: 98 - 97 | coded @: rot @: delblk f.

NB. check sum as text
cstxt =. _2{. '0', [: ": cs
NB. replace first two characters
chgps =. [,2}.]
NB. shift country code
rotlc =. 2&|.
NB. insert check digits (position 3 and 4)
insertps =. chgps &.rotlc

NB. IBAN with newly calculated check digits
ibancd =: (cstxt insertps ]) f.

NB. check / generate check digits
ibancheck =: ] (]`('ok'"_) @. -:) ibancd

NB. groups of four characters
insertblk =. #~ # $ 1 1 1 1j1"_
quads =: insertblk @: delblk f.

NB. IBAN
iban =: quads @: ibancheck
