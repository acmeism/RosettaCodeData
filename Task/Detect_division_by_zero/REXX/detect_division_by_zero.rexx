/*REXX program demonstrates  detects and handles  division by zero.     */

signal on syntax                       /*handle all REXX syntax errors. */
x = sourceline()                       /*being cute, x=size of this pgm.*/
y = x-x                                /*setting to zero the obtuse way.*/
z = x/y                                /*this'll do it, furrrr shurrre. */
exit                                   /*We're kaput.   Ja vohl !       */

/*───────────────────────────────error handling subroutines and others.─*/
err: if rc==42 then do;  say;  say     /*1st, check for a specific error*/
                    say center(' division by zero is a no-no. ',79,'═')
                         say;  say
                    exit 130
                    end

     say; say; say center(' error! ',max(40,linesize()%2),"*"); say
               do j=1 for arg(); say arg(j); say; end; say;
               exit 13

novalue: syntax: call err 'REXX program' condition('C') "error",,
             condition('D'),'REXX source statement (line' sigl"):",,
             sourceline(sigl)
