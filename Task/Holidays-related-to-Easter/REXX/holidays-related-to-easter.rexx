/* REXX **********************************************************************************
* Test frame for computing Christian (Roman Catholic) holidays, related to Easter
* 16.04.2013 Walter Pachl
* 08.03.2021 -"- extended range of years and indicate Roman Catholic use
*****************************************************************************************/
oid='ee.txt'; 'erase' oid

month.3='Mar'; days.3=31
month.4='Apr'; days.4=30
month.5='May'; days.5=31
month.6='Jun'; days.6=30
Call o 'Christian holidays, related to Easter, for each centennial',
                                                'from 400 to 2200 CE:'
Do y=400 To 2200 By 100
  Call line y
  End
Call o ' '
Call o 'Christian holidays, related to Easter, for years',
                                                'from 2010 to 2030 CE:'
Do y=2010 To 2030
  Call line y
  End
Exit

line: Parse Arg y
Parse Value easter(y) With y m d
Parse Value add(d,m,39) With ad am
Parse Value add(ad,am,10) With pd pm
Parse Value add(pd,pm,7) With td tm
Parse Value add(td,tm,4) With cd cm
ol=right(y,4) 'Easter:' right(d,2) month.m
ol=ol'  Ascension:' right(ad,2) month.am ' Pentecost:' right(pd,2) month.pm
ol=ol'  Trinity:' right(td,2) month.tm'  Corpus:' right(cd,2) month.cm
Call o ol
Return

o: Return lineout(oid,arg(1))

add: Procedure Expose days.
Parse Arg d,m,dd
res=d+dd
Do While res>days.m
  res=res-days.m
  m=m+1
  End
Return res m

easter: Procedure
/***********************************************************
* translated from FORTRAN (mod -> //; / -> %)
* Input  year
* Output year month day of Easter Sunday
* 16.04.2013 Walter Pachl
c See:
c Jean Meeus, "Astronomical Formulae for Calculators",
c 4th edition, Willmann-Bell, 1988, p.31
*********************************************************/
Parse Arg year
a=year//19
b=year%100
c=year//100
d=b%4
e=b//4
f=(b+8)%25
g=(b-f+1)%3
h=(19*a+b-d-g+15)//30
i=c%4
k=c//4
l=(32+2*e+2*i-h-k)//7
m=(a+11*h+22*l)%451
n=h+l-7*m+114
month=n%31
day=n//31+1
Return year month day
