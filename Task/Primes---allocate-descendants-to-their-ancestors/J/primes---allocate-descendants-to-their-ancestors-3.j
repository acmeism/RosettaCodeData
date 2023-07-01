getdescendants=: 3 : 0
  dd=: (<(>y{dd),y)y}dd
  y getproducts"0 >:i.maxsum-y
)

getproducts=: 4 : 'dd=: (<(>(x+y){dd),x*(>y{dd))(x+y)}dd'

delfalsechildren=: 3 : 'dd=: ((}:&.>)y{dd)y}dd'

report=: 3 : 0
  ac=. getancestors y
  if. (level=. #ac) = 0 do.
    ls=. 'None'
  else.
    ls=. (' ';', ') stringreplace ":ac
  end.
  line=. '[',(":y),'] Level: ',(":level),CR,LF,'Ancestors: ',ls,CR,LF
  if. (nb=. #>y{dd) = 0 do.
    line=. line,'Descendants: ','None',CR,LF,CR,LF
  else.
    ls=. (' ';', ') stringreplace ":/:~>y{dd
    line=. line,'Descendants: ',(":nb),CR,LF,ls,CR,LF,CR,LF
  end.
  line fappend file
)

getancestors=: |.@:(1}.+/@:q:^:a: ::(''"_))

main=: 3 : 0
  if. (pp1=. 9!:10 '') < 20 do. (9!:11) 20 end.
  '' fwrite file
  maxsum=: y
  dd=: (maxsum+1)$a:
  primes=. i.&.(p:inv)maxsum+1
  getdescendants"0 primes
  delfalsechildren"0 primes,4
  report"0 >:i.maxsum
  ('Total descendants ',":+/#&>dd) fappend file
  if. (pp2=. 9!:10 '') ~: pp1 do. (9!:11) pp1 end.
)

file=: jpath '~user/temp/Ancestors.ijs.txt'
main 99
