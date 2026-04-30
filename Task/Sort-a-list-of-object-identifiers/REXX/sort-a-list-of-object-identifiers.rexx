-- 4 Mar 2026
include Setting

say 'SORT A LIST OF OBJECT IDENTIFIERS'
say version
say
call Prepare
call Show 'BEFORE'
-- Sort key while syncing data (string compare)
call SortSt 'stem.key.','stem.data.'
call Show 'AFTER'
exit

Prepare:
procedure expose stem.
-- Input list
list=1.3.6.1.4.1.11.2.17.19.3.4.0.10 ,
     1.3.6.1.4.1.11.2.17.5.2.0.79 ,
     1.3.6.1.4.1.11.2.17.19.3.4.0.4 ,
     1.3.6.1.4.1.11150.3.4.0.1 ,
     1.3.6.1.4.1.11.2.17.19.3.4.0.1 ,
     1.3.6.1.4.1.11150.3.4.0
-- Copy to stems
n=Words(list); stem.=''; m=0
do i=1 to n
-- Original input in stem.data
   w=Word(list,i); stem.data.i=w
-- Modified keys in stem.key
   k=Changestr('.',w,' ')
   do j=1 to Words(k)
-- Keep length largest number
      m=Max(Length(Word(k,j)),m)
   end
   stem.key.i=k
end
stem.0=n
-- Prepend numbers in stem.key with spaces
do i=1 to n
   k=''
   do j=1 to Words(stem.key.i)
      k=k||Right(Word(stem.key.i,j),m)
   end
   stem.key.i=k
end
return

Show:
procedure expose stem.
arg header
say header
do i=1 to stem.0
   say stem.data.i
end
say
return

-- SortSt
include Math
