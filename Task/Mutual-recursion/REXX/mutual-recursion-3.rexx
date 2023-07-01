/*REXX program shows  mutual recursion  (via the Hofstadter Male and Female sequences). */
/*───────────────── If LIM is negative, a single result is shown for the abs(lim) entry.*/

parse arg lim .;       if lim==''  then lim= 99;           aLim= abs(lim)
w= length(aLim);       $m.=.;      $m.0= 0;     $f.=.;     $f.0= 1;    Js=;    Fs=;    Ms=

               do j=0  for aLim+1;     call F(J);          call M(j)
               if lim<0  then iterate
               Js= Js right(j, w);     Fs= Fs right($f.j, w);      Ms= Ms right($m.j, w)
               end   /*j*/

if lim>0  then  say 'Js='   Js;        else  say  'J('aLim")="     right(   aLim, w)
if lim>0  then  say 'Fs='   Fs;        else  say  'F('aLim")="     right($f.aLim, w)
if lim>0  then  say 'Ms='   Ms;        else  say  'M('aLim")="     right($m.aLIM, w)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
F: procedure expose $m. $f.; parse arg n; if $f.n==.  then $f.n= n-M(F(n-1));  return $f.n
M: procedure expose $m. $f.; parse arg n; if $m.n==.  then $m.n= n-F(M(n-1));  return $m.n
