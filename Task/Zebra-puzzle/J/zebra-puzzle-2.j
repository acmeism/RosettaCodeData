ehs=: 5$a:

cr=: (('English';'red') 0 3} ehs);<('Dane';'tea') 0 2}ehs
cr=: cr, (('German';'Prince') 0 4}ehs);<('Swede';'dog') 0 1 }ehs

cs=: <('PallMall';'birds') 4 1}ehs
cs=: cs, (('yellow';'Dunhill') 3 4}ehs);<('BlueMaster';'beer') 4 2}ehs

lof=: (('coffee';'green')2 3}ehs);<(<'white')3}ehs

next=: <((<'Blend') 4 }ehs);<(<'water')2}ehs
next=: next,<((<'Blend') 4 }ehs);<(<'cats')1}ehs
next=: next,<((<'Dunhill') 4}ehs);<(<'horse')1}ehs
