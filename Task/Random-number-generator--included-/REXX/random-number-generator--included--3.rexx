/* REXX ***************************************************************
* 08.09.2013 Walter Pachl
*            Please add the output from other REXXes
* 10.09.2013 Walter Pachl added REXX/TSO
**********************************************************************/
Parse Version v
Call random ,,44
ol=v':'
Do i=1 To 10
  ol=ol random(1,10)
  End
Say ol
