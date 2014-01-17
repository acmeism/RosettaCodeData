pad=: 0,0,~0,.0,.~]
life=: (_3 _3 (+/ e. 3+0,4&{)@,;._3 ])@pad
NB. the above could also be a one-line solution:
life=: (_3 _3 (+/ e. 3+0,4&{)@,;._3 ])@(0,0,~0,.0,.~])
