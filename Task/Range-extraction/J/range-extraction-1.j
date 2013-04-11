require 'strings'
fmt=: [: ;@(8!:0) [`]`({. ; (',-' {~ 2 < #) ; {:)@.(2 <. #)
group=: <@fmt;.1~ 1 ~: 0 , 2 -~/\ ]
extractRange=: ',' joinstring group
