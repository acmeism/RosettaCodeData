/*REXX pgm reads a file and displays it  (with word wrap to the screen).*/
parse arg iFID width justify _ .                 /*get optional CL args.*/
if iFID=''  |iFID==','   then iFID ='LAWS.TXT'   /*default input file ID*/
if width==''|width==','  then width=linesize()   /*Default? Use linesize*/
if width==0              then width=80           /*indeterminable width.*/
if right(width,1)=='%'   then do                 /*handle  %  of width. */
                              width=translate(width,,'%') /*remove the %*/
                              width=linesize() * translate(width,,"%")%100
                              end
if justify==''|justify==','  then justify='Left' /*Default?   Use  LEFT */
just=left(justify,1)                   /*only use first char of JUSTIFY.*/
upper just                             /*be able to handle mixed case.  */
if pos(just,'BCLR')==0   then call err "JUSTIFY (3rd arg) is illegal:"  justify
if _\==''                then call err "too many arguments specified."  _
if \datatype(width,'W')  then call err "WIDTH (2nd arg) isn't an integer:" width
n=0                                    /*number of words in the file.   */
      do j=0  while lines(iFID)\==0    /*read from the file until E-O-F.*/
      _=linein(iFID)                   /*get a record  (line of text).  */
        do  words(_)                   /*extract some words (maybe not).*/
        n=n+1;  parse var _ @.n _      /*get & assign next word in text.*/
        end   /*DO words(_)*/
      end     /*j*/
if j==0   then call err  'file'  iFID  "not found."
if n==0   then call err  'file'  iFID  "is empty  (or has no words)"
$=@.1                                  /*init da money bag with 1st word*/
    do m=2  for n-1;    x=@.m          /*parse until text (@) exhausted.*/
    _=$ x                              /*append it to the money and see.*/
    if length(_)>width  then call tell /*this word a bridge too far?  >w*/
    $=_                                /*the new words are OK so far.   */
    end   /*m*/
call tell                              /*handle any residual words.     */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ERR subroutine──────────────────────*/
err:  say;   say '***error!***';   say;   say arg(1);  say;  say;  exit 13
/*──────────────────────────────────TELL subroutine─────────────────────*/
tell: if $==''  then return            /*first word may be too long.    */
if just=='L' then                        $=  strip($)   /*left ◄────────*/
             else do
                  w=max(width,length($))    /*don't truncate long words.*/
                    select
                    when just=='R'  then $=  right($,w) /*──────► right */
                    when just=='B'  then $=justify($,w) /*◄────both────►*/
                    when just=='C'  then $= center($,w) /*  ◄centered►  */
                    end   /*select*/
                  end
say $                                  /*show and tell, or write──►file?*/
_=x                                    /*handle any word overflow.      */
return                                 /*go back and keep truckin'.     */
