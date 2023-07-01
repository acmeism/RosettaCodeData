/* REXX */
Parse Arg yyyymmdd
If arg(1)='' |,
   arg(1)='?' Then Do
  Say 'rexx wd yyyymmdd will show which weekday that is'
  Exit
  End
Parse Var yyyymmdd y +4 m +2 d
wd=.Array~of('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')
dt=.DateTime~new(y,m,d)
say yyyymmdd 'is a' wd[dt~weekday]
