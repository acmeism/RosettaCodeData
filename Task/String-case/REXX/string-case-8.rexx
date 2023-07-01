uppercase: /*courtesy Gerard Schildberger */
 return translate(changestr("ß",translate(arg(1),'ÄÖÜ',"äöü"),'SS'))

uppercase2: Procedure
Parse Arg a
  a=translate(arg(1),'ÄÖÜ',"äöü")     /* translate lowercase umlaute */
  a=changestr("ß",a,'SS')             /* replace ß with SS           */
  return translate(a)                 /* translate lowercase letters */
