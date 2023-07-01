NB. install'math/fftw'
require'math/fftw'

cyclotomic000=:  {{ assert.0<y
  if. y = 1 do. _1 1 return. end.
  'q p'=. __ q: y
  if. 1=#q do.
    ,(y%*/q) {."0 q#1
  elseif.2={.q do.
    ,(y%*/q) {."0 (* 1 _1 $~ #) cyclotomic */}.q
  elseif. 1 e. 1 < p do.
    ,(y%*/q) {."0 cyclotomic */q
  else.
    lgl=. {:$ ctlist=. cyclotomic "0 }:*/@>,{1,each q    NB. ctlist is 2-d table of polynomial divisors
    lgd=. # dividend=. _1,(-y){.1                        NB. (x^n) - 1, and its size
    lg=.  >.&.(2&^.)  lgl >. lgd                         NB. required lengths of all polynomials for fft transforms
                      NB. really, "divisor" is the fft of the divisor!
            divisor=. */ fftw"1 lg{."1 ctlist            NB. FFT article doesn't deal with lists of multiplicands
    unpad roundreal ifftw"1 divisor %~ fftw lg{.dividend NB. similar to article's multiplication
  end.
}}

roundreal =: [: <. 0.5 + 9&o.
