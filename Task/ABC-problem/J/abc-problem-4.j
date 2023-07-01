Blocks=:  >;:'BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM '
ExampleWords=: ;: 'A BaRK BOoK tREaT COmMOn SqUAD CoNfuSE '

canform=:4 :0
  word=: toupper y
  need=: #/.~ word,word
  relevant=: (x +./@e."1 word) # x
  candidates=: word,"1>,{ {relevant
  +./(((#need){. #/.~)"1 candidates) */ .>:need
)
