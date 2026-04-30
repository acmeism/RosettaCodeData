-- 10 Nov 2025
include Setting

say 'I BEFORE E AFTER C'
say version
say
call UnixDict
call Show
exit

UnixDict:
file='UnixDict.txt'
say 'Process' file'...'
n=0; cie=0; cei=0; xie=0; xei=0
do while Lines(file) > 0
   line=Lower(Linein(file)); n+=1
   a=Pos('ie',line)
   if a>0 then do
      a+=99*(a<2)
      if Substr(line,a-1,1)='c' then
         cie+=1
      else
         xie+=1
   end
   a=Pos('ei',line)
   if a>0 then do
      a+=99*(a<2)
      if Substr(line,a-1,1)='c' then
         cei+=1
      else
         xei+=1
   end
end
say n 'Lines processed'
say
return

Show:
say 'IE preceded by C occurs' cie 'times'
say 'EI preceded by C occurs' cei 'times'
say 'IE not preceded by C occurs' xie 'times'
say 'EI not preceded by C occurs' xei 'times'
say
ie=(2*xie<=cie); ei=(2*cei<=xei)
call Charout ,'I before E when not preceded by C is '
if ie then
   call Charout ,'not '
say 'plausible'
call Charout ,'E before I when preceded by C is '
if ei then
   call Charout ,'not '
say 'plausible'
call Charout ,'I before E except after C is '
if ie | ei then
   call Charout ,'not '
say 'plausible'
return

include Abend
