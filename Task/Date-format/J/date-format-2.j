require 'dates system/packages/misc/datefmt.ijs'
days=:;:'Sunday Monday Tuesday Wednesday Thursday Friday Saturday'
fmtDate=: [:((days ;@{~ weekday),', ',ms0) 3 {.]

   fmtDate 6!:0 ''
Thursday, August 19, 2010
