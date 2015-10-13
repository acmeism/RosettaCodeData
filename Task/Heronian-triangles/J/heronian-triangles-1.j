a=: 0&{"1
b=: 1&{"1
c=: 2&{"1
s=: (a+b+c) % 2:
area=: 2 %: s*(s-a)*(s-b)*(s-c)                   NB. Hero's formula
perim=: +/"1
isPrimHero=: (0&~: * (= <.@:+))@area * 1 = a +. b +. c
