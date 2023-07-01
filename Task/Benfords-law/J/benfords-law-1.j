benford=: 10&^.@(1 + %)                  NB. expected frequency of first digit y
Digits=: '123456789'
firstSigDigits=: {.@(-. -.&Digits)@":"0  NB. extract first significant digit from numbers

freq=: (] % +/)@:<:@(#/.~)@,             NB. calc frequency of values (x) in y
