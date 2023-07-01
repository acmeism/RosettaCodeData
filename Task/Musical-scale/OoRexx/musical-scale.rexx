/* REXX ---------------------------------------------------------------
* 24.02.2013 Walter Pachl derived from original REXX version
* Changes: sound(f,sec) --> beep(trunc(f),millisec)
*          $ -> sc
*          @. -> f.
*          re > ra (in sc)
*--------------------------------------------------------------------*/
  sc='do ra mi fa so la te do'
  dur=1250                          /* milliseconds                   */
  Do j=1 For words(sc)              /* sound each "note" in the string*/
    Call notes word(sc,j),dur       /* invoke a subroutine for sounds.*/
    End                             /* j                              */
  Exit                              /* stick a fork in it, we're done.*/
notes: Procedure
  Arg note,dur
  f.=0                              /* define common names for sounds.*/
  f.la=220
  f.si=246.94
  f.te=f.si
  f.ta=f.te
  f.ti=f.te
  f.do=261.6256
  f.ut=f.do
  f.ra=293.66
  f.re=f.ra     /* re is to be a synonym for ra */
  f.mi=329.63
  f.ma=f.mi
  f.fa=349.23
  f.so=392
  f.sol=f.so
  Say note trunc(f.note) dur
  If f.note\==0 Then
    Call beep trunc(f.note),dur     /* sound the "note".              */
  Return
