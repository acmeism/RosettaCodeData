"/ find { s. e. n. d. m. o. r. y.}
"/ such that:
"/       send
"/    +  more
"/    -------
"/    = money

result :=
  Amb try:(0 to:9) in:[:s |
  Amb try:(0 to:9) in:[:e |  e~=s ifTrue:[
  Amb try:(0 to:9) in:[:n |  (n~=e)&(n~=s) ifTrue:[
  Amb try:(0 to:9) in:[:d |  (d~=n)&(d~=e)&(d~=s) ifTrue:[
  Amb try:(1 to:1) in:[:m |  (m~=d)&(m~=n)&(m~=e)&(m~=s) ifTrue:[
  Amb try:(0 to:9) in:[:o |  (o~=m)&(o~=d)&(o~=n)&(o~=e)&(o~=s) ifTrue:[
  Amb try:(0 to:9) in:[:r |  (r~=o)&(r~=m)&(r~=d)&(r~=n)&(r~=e)&(r~=s) ifTrue:[
  Amb try:(0 to:9) in:[:y |  (y~=r)&(y~=o)&(y~=m)&(y~=d)&(y~=n)&(y~=e)&(y~=s) ifTrue:[
        (
               (              (1000 * s) + (100 * e) + (10 * n) + d)
            +  (              (1000 * m) + (100 * o) + (10 * r) + e)
            =  ((10000 * m) + (1000 * o) + (100 * n) + (10 * e) + y)
        ) ifTrue:[
            Transcript showCR: e'      {s}{e}{n}{d}'.
            Transcript showCR: e' +    {m}{o}{r}{e}'.
            Transcript showCR: e' -----------'.
            Transcript showCR: e' =   {m}{o}{n}{e}{y}'.
            {'s'->s . 'e'->e . 'n'->n . 'd'->d . 'm'->m . 'o'->o . 'r'->r . 'y'->y }
        ].
   ]]]]]]]]]]]]]]].
Transcript cr; showCR: result.
