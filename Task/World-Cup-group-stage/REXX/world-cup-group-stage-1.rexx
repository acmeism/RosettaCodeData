/* REXX -------------------------------------------------------------------*/
results = '000000'                      /*start with left teams all losing */
games = '12 13 14 23 24 34'
points.=0
records.=0
Do Until nextResult(results)=0
  records.=0
  Do i=1 To 6
    r=substr(results,i,1)
    g=word(games,i); Parse Var g g1 +1 g2
    Select
      When r='2' Then                   /* win for left team               */
        records.g1=records.g1+3
      When r='1' Then Do                /* draw                            */
        records.g1=records.g1+1
        records.g2=records.g2+1
        End
      When r='0' Then                   /* win for right team              */
        records.g2=records.g2+3
      End
    End
  Call sort_records                     /* sort ascending,                 */
                                        /* first place team on the right   */
  r1=records.1
  r2=records.2
  r3=records.3
  r4=records.4
  points.0.r1=points.0.r1+1
  points.1.r2=points.1.r2+1
  points.2.r3=points.2.r3+1
  points.3.r4=points.3.r4+1
  End
ol.='['
sep=', '
Do i=0 To 9
  If i=9 Then sep=']'
  ol.0=ol.0||points.0.i||sep
  ol.1=ol.1||points.1.i||sep
  ol.2=ol.2||points.2.i||sep
  ol.3=ol.3||points.3.i||sep
  End
Say ol.3
Say ol.2
Say ol.1
Say ol.0
Exit

nextResult: Procedure Expose results
/* results is a string of 6 base 3 digits to which we add 1                */
/* e.g., '000212 +1 -> 000220                                              */
If results="222222" Then Return 0
res=0
do i=1 To 6
  res=res*3+substr(results,i,1)
  End
res=res+1
s=''
Do i=1 To 6
  b=res//3
  res=res%3
  s=b||s
  End
results=s
Return 1

sort_records: Procedure Expose records.
Do i=1 To 3
  Do j=i+1 To 4
    If records.j<records.i Then
      Parse Value records.i records.j With records.j records.i
    End
  End
Return
