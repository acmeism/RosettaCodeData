/* REXX */
patients='patients.csv'
l=linein(patients)
Parse Var l h1 ',' h2
n=0
idl=''
Do n=1 By 1 While lines(patients)>0
  l=linein(patients)
  Parse Var l id ',' lastname.id
  idl=idl id
  End
n=n-1 /* number of patients */
visits='visits.csv'
l=linein(visits) /* skip the header line of this file */
h3='LAST_VISIT'
h4='SCORE_SUM'
h5='SCORE_AVG'
date.=''
score.=0
Say '|' h1 '|' h2 '|' h3 '|' h4 '|' h5 '|'
Do While lines(visits)>0
  l=linein(visits)
  Parse Var l id ',' date ',' score
  if date>date.id Then date.id=date
  If score>'' Then Do
    z=score.id.0+1
    score.id.z=score
    score.id.0=z
    End
  end
idl=wordsort(idl)
Do While idl<>''
  Parse Var idl id idl
  If date.id='' Then date.id=copies(' ',10)
  ol='|' left(id,length(h1)) '|' left(lastname.id,length(h2)),
                             '|' left(date.id,length(h3))
  If score.id.0=0 Then Do
  ol=ol '|' left(' ',length(h4)) '|',
            left(' ',length(h5)) '|'
    score_sum=copies(' ',length(h4))
    score_avg=copies(' ',length(h4))
    End
  Else Do
    score_sum=0
    Do j=1 To score.id.0
      score_sum=score_sum+score.id.j
      End
    score_avg=score_sum/score.id.0
    ol=ol '|' left(format(score_sum,2,1),length(h4)) '|',
             left(format(score_avg,2,1),length(h5)) '|'
    End
  Say ol
  End
Exit

wordsort: Procedure
/**********************************************************************
* Sort the list of words supplied as argument. Return the sorted list
**********************************************************************/
  Parse Arg wl
  wa.=''
  wa.0=0
  Do While wl<>''
    Parse Var wl w wl
    Do i=1 To wa.0
      If wa.i>w Then Leave
      End
    If i<=wa.0 Then Do
      Do j=wa.0 To i By -1
        ii=j+1
        wa.ii=wa.j
        End
      End
    wa.i=w
    wa.0=wa.0+1
    End
  swl=''
  Do i=1 To wa.0
    swl=swl wa.i
    End
  Return strip(swl)
