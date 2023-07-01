/* REXX */
dats='20071123'
Say date('I',dats,'S')
Say date('W',dats,'S')',' date('M',dats,'S') substr(dats,7,2)',' left(dats,4)
Say date('W',dats,'S')',' date('M',dats,'S') translate('gh, abcd',dats,'abcdefgh')
dati=date('I')
Say dati
Say date('W',dati,'I')',' date('M',dati,'I') translate('ij, abcd',dati,'abcdefghij')
