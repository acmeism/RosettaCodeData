NB. standard profile defines  tolower  and  delete extra blanks.
load'number_names.ijs'

NB. replace J's stdlib 'cut' with a variant which supports multi-character delimiters
cut =: #@:[ }.&.> [ (E. <;.1 ]) ,

usinv =: 3 : 0
 U =. 'ones' ; }. ENU
 A0 =. ;@:(' and'&cut)^:([: +./ ' and '&E.) tolower deb y NB. standardize to us form.
 A =. ,&' ones'^:(U -.@e.~ [: {: ;:) A0
 B =. ', ' cut A NB. box the comma separated phrases.
 C =. ' ' cut L:0 B NB. box words within phrases.
 M =. ENU (1000x ^ #@:[ | (i. {:&>)) C  NB. powers of 1000
 assert *./ 2 >/\ M NB. the phrases properly ordered.
 D=. (<'hundred')&cut&> C
 M +/ .*+/"1 ,"2 (([: (* 100 ^ 2 ~: #) (#EN100)|EN100&i.)&>)D
)
