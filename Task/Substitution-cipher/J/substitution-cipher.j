keysubst=: [`(a.i.])`(a."_)}
key=: 'Taehist' keysubst '!@#$%^&'
enc=: a. {~ key i. ]
dec=: key {~ a. i. ]

   enc 'This is a test.'
!$%^ %^ @ &#^&.
   dec '!$%^ %^ @ &#^&.'
This is a test.
