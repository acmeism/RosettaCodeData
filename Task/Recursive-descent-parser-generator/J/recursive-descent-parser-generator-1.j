cocurrent 'base'

inlocale=: 4 :0 L:0
  x,'_',y,'_'
)

parse=: 3 :0
  sentence=. ;:y
  opinds=. (;:'+*-')i.sentence
  opfuns=. (;:'plus times minus') inlocale 'base'
  scratch=. cocreate''
  coinsert__scratch 'base'
  names=. ~.sentence#~_1<:nc sentence
  (names inlocale scratch)=: names
  r=. do__scratch ;:inv opinds}((#sentence)#"0 opfuns),sentence
  codestroy__scratch''
  r
)

term=: 1 :0
  2 :('m''',m,'''expr n')
)

expr=:1 :0
:
  r=. genname''
  emit r,'=:',x,m,y
  r
)

plus=: '+' expr
times=: '*' term
minus=: '-' expr

N=: 10000
genname=: 3 :0
  'z',}.":N=: N+1
)

emit=: smoutput
