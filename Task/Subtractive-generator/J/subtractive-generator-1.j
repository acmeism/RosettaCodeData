came_from_locale_sg_=: coname''
cocurrent'sg' NB. install the state of rng sg into locale sg

SEED=: 292929
'I J M first_Bentley_number B2'=: 55 24 1e9 34 165
SG=: 1 : 'M&|@:-/@:(m&{)'
r=: (I|(first_Bentley_number*>:i.I)) { (, _2 _1 SG)^:(I-2) 1,~SEED

sg=: 3 : 0
t=. (, (-I,J)SG)^:y r
r=: y }. t
t {.~ -y
)
discard=. sg B2

cocurrent came_from_locale  NB. return to previous locale
sg=: sg_sg_                 NB. make a local name for sg in locale sg
