ops=: > , { 3#<'+-*%'
perms=: [: ":"0 [: ~. i.@!@# A. ]
build=: 1 : '(#~ 24 = ".) @: u'

combp=: dyad define
'a b c d'=. y['f g h'=. x
('(',a,f,b,g,c,')',h,d),('(',a,f,b,')',g,c,h,d),(a,f,'(',b,g,c,')',h,d),:('((',a,f,b,')',g,c,')',h,d)
)

math24=: monad define
assert. 4 = # y NB. prefer expressions without parens & fallback if needed
es=. ([: ,/ ops ([: , (' ',[) ,. ])"1 2/ perms) build y
if. 0 = #es do. es =. ([: ,/ [: ,/ ops combp"1 2/ perms) build y end.
es -."1 ' '
)
