require 'trig'
atan2=: {:@*.@j. NB. arc tangent of y divided by x

horiz=: verb define
  'lat lng ref'=. y
  out=. smoutput@,&":
  'Latitude         ' out lat
  'Longitude        ' out lng
  'Legal meridian   ' out ref
  'Sine of latitude ' out slat=. sin rfd lat
  'Diff longitude   ' out -diff=. ref - lng
  lbl=.'hour  ';'sun hour angle  ';'dial hour line angle'
  r=.((,. (,. (atan2 *&slat)/@+.@r.&.rfd)) diff + 15&*) i:6
  smoutput lbl ,: ('3.0';'7.3';'7.3') 8!:1 r
)
