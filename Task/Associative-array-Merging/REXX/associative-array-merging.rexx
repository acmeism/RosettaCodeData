-- 8 Aug 2025
include Settings

say 'ASSOCIATIVE ARRAY: MERGE'
say version
say
call CreateBase
call ShowBase 'Original'
call CreateUpdate
call ShowUpdate
call MergeBaseUpdate
call ShowBase 'Merged'
exit

CreateBase:
base=''; base.=''
call ProcBase 'name','Rocket Skates'
call ProcBase 'price',12.75
call ProcBase 'color','Yellow'
return

ShowBase:
parse arg xx
sep=Copies('-',20)
say 'Base array' xx
say sep
say 'Key    value'
say sep
do i = 1 to Words(base)
   key=Word(base,i)
   say Left(key,6) base.key
end
say sep
say
return

CreateUpdate:
upda=''; upda.=''
call ProcUpdate 'price',15.25
call ProcUpdate 'color','Red'
call ProcUpdate 'year',1974
return

ShowUpdate:
say 'Update array'
say sep
say 'Key    value'
say sep
do i = 1 to Words(upda)
   key=Word(upda,i)
   say Left(key,6) upda.key
end
say sep
say
return

MergeBaseUpdate:
do w = 1 to Words(upda)
   key=Word(upda,w); val=upda.key
   call ProcBase key,val
end
return

ProcBase:
parse arg k,v
if WordPos(k,base) = 0 then
   base=base k
base.k=v
return

ProcUpdate:
parse arg k,v
if WordPos(k,upda) = 0 then
   upda=upda k
upda.k=v
return

include Abend
