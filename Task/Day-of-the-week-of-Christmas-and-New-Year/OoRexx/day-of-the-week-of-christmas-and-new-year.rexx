/* REXX */
Call wkd 2021,12,25
Call wkd 2022,01,01
Exit
wkd:
Parse Arg y,m,d
wd=.Array~of('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')
dt=.DateTime~new(y,m,d)
say d'.'m'.'y 'is a' wd[dt~weekday]
Return
