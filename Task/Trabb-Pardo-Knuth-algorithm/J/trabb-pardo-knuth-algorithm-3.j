get11numbers=: 3 :0
  smoutput 'Enter 11 numbers: '
  _&". 1!:1]1
)

f_x=: %:@| + 5 * ^&3

overflow400=: 'user alert'"_`":@.(<:&400)"0

tpk=: overflow400@f_x@|.@get11numbers
