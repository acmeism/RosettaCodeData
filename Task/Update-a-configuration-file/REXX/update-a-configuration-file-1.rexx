/*REXX program demonstrates how to  update  a configuration file  (four specific tasks).*/
parse arg iFID oFID .                            /*obtain optional arguments from the CL*/
if iFID=='' | iFID==","  then iFID=      'UPDATECF.TXT'  /*Not given?  Then use default.*/
if oFID=='' | oFID==","  then oFID='\TEMP\UPDATECF.$$$'  /* "    "       "   "     "    */
call lineout iFID;  call lineout oFID            /*close the input and the output files.*/
$.=0                                             /*placeholder of the options detected. */
call dos  'ERASE'  oFID                          /*erase a file (with no error message).*/
changed=0                                        /*nothing changed in the file (so far).*/
                                                 /* [↓]  read the entire  config  file. */
  do rec=0  while lines(iFID)\==0                /*read a record; bump the record count.*/
  z=linein(iFID);          zz=space(z)           /*get record;  elide extraneous blanks.*/
  say '───────── record:'  z                     /*echo the record just read ──► console*/
  a=left(zz,1);  _=space( translate(zz, ,';') )  /*_:  is used to elide multiple  ";"   */
  if zz=='' | a=='#'  then do; call cpy z; iterate; end            /*blank or a comment.*/
  if _==''  then do; changed=1; iterate; end     /*elide any semicolons;  empty records.*/
  parse upper var z op .                         /*obtain the option from the record.   */
                                                 /* [↓]   option may have leading or ···*/
  if a==';'  then do;   parse upper var z 2 op .                      /*trailing blanks.*/
                  if op='SEEDSREMOVED'  then call new space( substr(z, 2) )
                  call cpy z;  $.op=1            /*write the Z record to the output file*/
                  iterate  /*rec*/               /* ··· and then go read the next record*/
                  end
  if $.op  then do;  changed=1;  iterate;  end   /*is the  option  already defined?     */
  $.op=1                                         /* [↑]  Yes?   Then delete it.         */
  if op=='NEEDSPEELING'          then call new  ";"    z
  if op=='NUMBEROFBANANAS'       then call new  op  1024
  if op=='NUMBEROFSTRAWBERRIES'  then call new  op  62000
  call cpy z                                     /*write the Z record to the output file*/
  end   /*rec*/

     nos='NUMBEROFSTRAWBERRIES'                  /* [↓]  Does NOS option need updating? */
if \$.nos   then do;  call new nos 62000;  call cpy z;  end             /*update option.*/
call lineout iFID;    call lineout oFID          /*close the input and the output files.*/
if rec==0   then do;  say "ERROR:  input file wasn't found:"  iFID;  exit;  end
if changed  then do                              /*possibly overwrite the input file.   */
                 call dos 'XCOPY' oFID iFID '/y /q',">nul"                     /*quietly*/
                 say;   say center('output file', 79, "▒")                     /*title. */
                 call dos 'TYPE'  oFID           /*display content of the output file.  */
                 end
call dos 'ERASE'  oFID                           /*erase a file (with no error message).*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
cpy:  call lineout oFID, arg(1);        return   /*write one line of text ───► oFID.    */
dos:  ''arg(1) word(arg(2) "2>nul",1);  return   /*execute a  DOS  command  (quietly).  */
new:  z=arg(1);    changed=1;           return   /*use new Z, indicate changed record.  */
