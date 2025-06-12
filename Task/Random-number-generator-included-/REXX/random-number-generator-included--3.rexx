/* REXX ***************************************************************
* 08.09.2013 Walter Pachl
*            Please add the output from other REXXes
* 10.09.2013 Walter Pachl added REXX/TSO
* 01.08.2014 Walter Pachl show what ooRexx supports
* 03.05.2025 Zeddicus added REXX/2
* 08.05.2025 Zeddicus added ooRexx 5.1
**********************************************************************/
Parse Version v
Call random ,,44
ol=v':'
Do i=1 To 10
  ol=ol random(1,10)
  End
If left(v,11)='REXX-ooRexx' Then
  ol=ol random(-999999999,0) /* ooRexx supports negative limits */
Say ol
