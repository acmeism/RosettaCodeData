-- 16 Jul 2026
include Setting

say 'READ A CONFIGURATION FILE'
say version
say
call ReadConfig 'Config.txt'
call ShowVars
exit

ReadConfig:
parse arg config
call Stream config,'c','open read'
do while Lines(config)>0
   line=Translate(linein(config),' ','=')
   select
      when line='' then
         nop
      when Pos(Left(line,1),'#;')>0 then
         nop
      when Pos(',',line)=0 then do
         parse var line variable val
         if val='' then
            val=1
         call Value variable,val
      end
      otherwise do
         stem=Word(line,1)'.'
         parse var line . line; n=0
         do while line<>''
            parse var line val ',' line
            val=Strip(val); n+=1
            call Value stem||n,val
         end
         call Value stem||0,n
      end
   end
end
call Stream config,'c','close'
return 0

-- Showvars
include Math
