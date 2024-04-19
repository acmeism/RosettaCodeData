/*REXX program validates a user  "word"  against a  "command table"  with abbreviations.*/
Parse Arg uw                                     /*obtain optional arguments from the CL*/
If uw='' Then uw= 'riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin'
Say 'user words: '   uw

keyws= 'add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3',
   'compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate',
   '3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2',
   'forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load',
   'locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2',
   'msg  next 1 overlay 1 Parse preserve 4 purge 3 put putD query 1 quit  read recover 3',
   'refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left',
   '2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1'

Say 'full words: ' validate(uw)                /*display the result(s) to the terminal*/
Exit                                             /*stick a fork in it,  we're all done. */
/*--------------------------------------------------------------------------------------*/
validate: Procedure Expose keyws
  keyws=translate(keyws)
  Arg userwords                              /*ARG   capitalizes all the userwords. */
  res=''                                     /*initialize the Return string to null.*/
  Do j=1 to words(userwords)                 /* loop over userwords                 */
    uword=word(userwords,j)                  /*obtain a word from the userword list.*/
    Do k=1 to words(keyws)                   /* loop over keywords                  */
      kw=word(keyws,k)                    /*get a legitmate command name from keyws.*/
      L=word(keyws,k+1)                       /*··· and maybe get its abbrev length.*/
      If datatype(L,'W') Then                 /* it's a number - an abbrev length.  */
        k=k + 1                               /* skip it for next kw                */
      Else                                    /* otherwise                          */
        L=length(kw)                           /*    it can't be abbreviated.        */
      If abbrev(kw,uword,L) Then Do           /* is valid abbreviation              */
        res=res kw                            /* add to result string               */
        Iterate j                             /* proceed with next userword         */
        End
      End
    res=res '*error*'                         /*processed the whole list, not valid */
    End
  Return strip(res)                           /* elide superfluous leading blank.   */
