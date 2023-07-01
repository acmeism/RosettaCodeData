NB. legit { , and } do not follow a legit backslash:
legit=: 1,_1}.4>(3;(_2[\"1".;._2]0 :0);('\';a.);0 _1 0 1)&;:&.(' '&,)
 2 1   1 1 NB. result 0 or 1: initial state
 2 2   1 2 NB. result 2 or 3: after receiving a non backslash
 1 2   1 2 NB. result 4 or 5: after receiving a backslash
)

expand=:3 :0
  Ch=. u:inv y
  M=. N=. 1+>./ Ch
  Ch=. Ch*-_1^legit y
  delim=. 'left comma right'=. u:inv '{,}'
  J=. i.K=. #Ch
  while. M=. M+1 do.
    candidates=. i.0 2
    for_check.I. comma=Ch do.
      begin=. >./I. left=check{. Ch
      end=. check+<./I. right=check}. Ch
      if. K>:end-begin do.
        candidates=. candidates,begin,end
      end.
    end.
    if. 0=#candidates do. break. end.
    'begin end'=. candidates{~(i.>./) -/"1 candidates
    ndx=. I.(begin<:J)*(end>:J)*Ch e. delim
    Ch=. M ndx} Ch
  end.
  T=. ,<Ch
  for_mark. |.N}.i.M  do.
    T=. ; mark divide each T
  end.
  u: each |each T
)

divide=:4 :0
  if. -.x e. y do. ,<y return. end.
  mask=. x=y
  prefix=. < y #~ -.+./\ mask
  suffix=. < y #~ -.+./\. mask
  options=. }:mask <;._1 y
  prefix,each options,each suffix
)
