isInt=: = <.                                     NB. are numbers integers?
sqrcube=: 2 3 %:/ ]                              NB. table of 2nd and 3rd roots of y
isSqrNotCubeofInt=: (*. -.)/@isInt@sqrcube       NB. is y the square but not cube of an integer?

getIdx=: {. I.                                   NB. get indicies of first x ones in boolean y

process_more=: adverb def '] , [: u (i.200) + #@]'  NB. process the next 200 indicies with u and append to y
notEnough=: > +/                                 NB. is left arg greater than sum of right arg
while=: conjunction def 'u^:v^:_'                NB. repeat u while v is true

process_until_enough=: adverb def 'u process_more while notEnough u'
