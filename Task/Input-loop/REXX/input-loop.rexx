-- 23 Aug 2025
include Setting

say 'INPUT LOOP'
say version
say
call Streaming
call Pulling
exit

Streaming:
say 'Using LineIn and LineOut...'
do until input = ''
   input=LineIn()
   call LineOut ,input
end
return 0

Pulling:
say 'Using pull and say...'
do until input = ''
   parse pull input
   say input
end
return 0

include Abend
