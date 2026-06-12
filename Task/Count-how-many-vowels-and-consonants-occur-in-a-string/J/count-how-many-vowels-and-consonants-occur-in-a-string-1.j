vowel=: (,toupper) 'aeiou'
consonant=: (,toupper) (a.{~97+i.16) -. vowel
vctally=: e.&vowel ,&(+/) e.&consonant
