DAT=: {{ require'web/gethttp csv'
  if.0=#$fread F=.'airports.dat' do.
    (gethttp y) fwrite F
  end.
  readcsv F
}}'https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat'
LATLONG=: _".&>6 7{"1 DAT

fmtm=: {{
 9!:7]9 1 1#'  -'
 r=._1 _1}.1 1}.":boxopen y
 ~.r[9!:7]9 1 1#'+|-'
}}
AIRPORTS=: 1 3 5{"1 DAT

deg=: %&180p_1     NB. convert from degrees
R=:  21600 % 2p1   NB. radius of spherical  earth in nautical miles

dist=: {{R*2*_1 o.1<.%:(*:1 o.0.5*x-y)p.x*&(2 o.{.)y}}&deg
bear=: {{
  re=. (2 o.{.y)*1 o.dlon=.y-&{:x
  2p1|1r2p1-{:*.re j. ((*|.)/+.^j.x,&{.y) p.-2 o.dlon
}}&.deg

NB. round y to nearest whole number under multiplying by x
pkg=: {{ <"0 (<.0.5+x*y)%x }}

LABELS=: ;:'Airport Country ICAO Distance Bearing'

nearest=: {{
  ndx=. 20{./: d=. y dist"1 LATLONG     NB. 20 nearest airports
  fmtm LABELS,(ndx{AIRPORTS),"1 (10 pkg ndx{d),.1 pkg y bear"1 ndx{LATLONG
}}
