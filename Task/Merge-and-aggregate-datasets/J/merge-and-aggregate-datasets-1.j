NB. setup:
require'jd pacman'
load JDP,'tools/csv_load.ijs'
F=: jpath '~temp/rosettacode/example/CSV'
jdcreatefolder_jd_ CSVFOLDER=: F

assert 0<{{)n
PATIENTID,LASTNAME
1001,Hopper
4004,Wirth
3003,Kemeny
2002,Gosling
5005,Kurtz
}} fwrite F,'patients.csv'

assert 0<{{)n
PATIENTID,VISIT_DATE,SCORE
2002,2020-09-10,6.8
1001,2020-09-17,5.5
4004,2020-09-24,8.4
2002,2020-10-08,
1001,,6.6
3003,2020-11-12,
4004,2020-11-05,7.0
1001,2020-11-19,5.3
}} fwrite F,'visits.csv'

csvprepare 'patients';F,'patients.csv'
csvprepare 'visits';F,'visits.csv'

csvload 'patients';1
csvload 'visits';1

jd'ref patients PATIENTID  visits PATIENTID'
