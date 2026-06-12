-- 10 Sep 2025
include Setting

say 'ASSERTIONS IN DESIGN BY CONTRACT'
say version
say
do forever
   a=Random(1,9); b=Random(1,9)
   call Assert (Date('w') <> 'Friday'),'Hey dude, not on parttime day!'
   call Assert (Time('h') <> 12),'Hey dude, not during lunch hour!'
   call Assert (a > 1 & b > 1),'Both a and b must be above 1'
   say 'a =' a 'and b =' b 'passed'
end
exit

include Math
