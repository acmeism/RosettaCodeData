/*REXX pgm shows how to update a configuration file  (4 specific tasks).*/
parse arg iFID oFID .                  /*obtain optional input file─id. */
if iFID=='' | iFID==','  then iFID=      'UPDATECF.TXT'  /*use default? */
if oFID=='' | oFID==','  then oFID='\TEMP\UPDATECF.$$$'  /*use default? */
call lineout iFID;  call lineout oFID  /*close the input & output files.*/
$.=0                                   /*placeholder of options found.  */
call dos 'ERASE' oFID                  /*erase a file (with no err MSGs)*/
changed=0                              /*nothing changed in file so far.*/
                                       /* [↓]  read the entire cfg file.*/
  do rec=0  while lines(iFID)\==0      /*read a record; bump record cnt.*/
  z=linein(iFID);          zz=space(z) /*get rec; del extraneous blanks.*/
  say '───────── record:'  z           /*echo the record just read──►con*/
  a=left(zz,1);  _=space(translate(zz,,';')) /*_ is used to elide multi;*/
  if zz=='' | a=='#'  then do; call cpy z; iterate; end  /*blank|comment*/
  if _==''  then do; changed=1; iterate; end /*elide any ; empty records*/
  parse upper var z op .               /*obtain the option from the rec.*/
                                       /* [↓]   OP  may have leading or */
  if a==';'  then do;   parse upper var z 2 op .      /*trailing blanks.*/
                  if op='SEEDSREMOVED'  then call new space(substr(z,2))
                  call cpy z;  $.op=1  /*write the  Z  record to output.*/
                  iterate  /*rec*/     /*··· and go read the next record*/
                  end
  if $.op  then do;  changed=1;  iterate;  end /*option already defined?*/
  $.op=1                                       /* [↑]  Yes?   Delete it.*/
  if op=='NEEDSPEELING'          then call new  ';' z
  if op=='NUMBEROFBANANAS'       then call new  op 1024
  if op=='NUMBEROFSTRAWBERRIES'  then call new  op 62000
  call cpy z                           /*write the  Z  record to output.*/
  end   /*rec*/

     nos='NUMBEROFSTRAWBERRIES'        /* [↓]  NOS option need updating?*/
if \$.nos  then do; call new nos 62000;  call cpy z; end   /*update opt.*/
call lineout iFID;  call lineout oFID  /*close the input & output files.*/
if rec==0  then do; say "ERROR:  input file wasn't found:" iFID; exit; end
if changed  then do                    /*possibly overwrite input file. */
                 call dos 'XCOPY' oFID iFID '/y /q',">nul"     /*quietly*/
                 say;   say center('output file', 79, "▒")     /*title. */
                 call dos 'TYPE'  oFID /*display output file's content. */
                 end
call dos 'ERASE'  oFID                 /*erase a file  (with no err msg)*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────one─line subroutines────────────────*/
cpy: call lineout oFID,arg(1); return  /*write one line of text───►oFID.*/
dos: ''arg(1) word(arg(2) "2>nul",1);  return   /*execute a DOS command.*/
new: z=arg(1);    changed=1;   return  /*use new Z, indicate changed rec*/
