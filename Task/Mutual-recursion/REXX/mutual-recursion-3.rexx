/*REXX program shows mutual recursion (via Hofstadter Male & Female sequence).*/
/*If LIM is negative,  only show a single result for the abs(lim) entry.*/

parse arg lim .;     if lim==''  then lim=99;     aLim=abs(lim)
w=length(aLim);      $m.=;    $m.0=0;    $f.=;    $f.0=1;    Js=;    Fs=;    Ms=

               do j=0  to Alim
               Js=Js right(j,w);    Fs=Fs right(F(j),w);     Ms=Ms right(M(j),w)
               end   /*j*/

if lim>0  then  say 'Js='   Js;        else  say  'J('aLim")="   word(Js,aLim+1)
if lim>0  then  say 'Fs='   Fs;        else  say  'F('aLim")="   word(Fs,aLim+1)
if lim>0  then  say 'Ms='   Ms;        else  say  'M('aLim")="   word(Ms,aLim+1)
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────one─liner subroutines─────────────────────────────*/
F: procedure expose $m. $f.; parse arg n; if $f.n=='' then $f.n=n-M(F(n-1)); return $f.n
M: procedure expose $m. $f.; parse arg n; if $m.n=='' then $m.n=n-F(M(n-1)); return $m.n
