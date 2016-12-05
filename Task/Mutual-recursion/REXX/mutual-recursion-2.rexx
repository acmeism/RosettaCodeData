/*REXX program shows  mutual recursion  (via the Hofstadter Male and Female sequences). */
parse arg lim .;      if lim==''  then lim=40             /*assume the default for LIM? */
w=length(lim);        $m.=.;    $m.0=0;     $f.=.;    $f.0=1;     Js=;     Fs=;     Ms=

               do j=0  to lim
               Js=Js right(j, w);      Fs=Fs right(F(j), w);      Ms=Ms right(M(j), w)
               end   /*j*/
say 'Js='  Js                                    /*display the list of  Js  to the term.*/
say 'Fs='  Fs                                    /*   "     "    "   "  Fs   "  "    "  */
say 'Ms='  Ms                                    /*   "     "    "   "  Ms   "  "    "  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
F: procedure expose $m. $f.; parse arg n;  if $f.n==. then $f.n=n-M(F(n-1));   return $f.n
M: procedure expose $m. $f.; parse arg n;  if $m.n==. then $m.n=n-F(M(n-1));   return $m.n
