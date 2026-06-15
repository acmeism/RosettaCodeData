-- 12 Jun 2026
include Setting

say 'FUNCTION COMPOSITION'
say version
say
parse value 'Sin' 'ArcSin' 0.5 with ff gg xx
say 'Compose('ff','gg','xx')' '=' Compose(ff,gg,xx) ',' ff'('gg'('xx'))' '=' Sin(ArcSin(xx))
parse value 'ArcSin' 'Sin' 0.5 with ff gg xx
say 'Compose('ff','gg','xx')' '=' Compose(ff,gg,xx) ',' ff'('gg'('xx'))' '=' ArcSin(Sin(xx))
parse value 'Zeta' 'Gamma' 0.5 with ff gg xx
say 'Compose('ff','gg','xx')' '=' Compose(ff,gg,xx) ',' ff'('gg'('xx'))' '=' Zeta(Gamma(xx))
exit

Compose:
procedure
arg ff,gg,xx
interpret 'rr='ff'('gg'('xx'))'
return rr

include Math
