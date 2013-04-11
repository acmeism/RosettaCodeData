/*REXX program shows mutual recursion (via Hofstadter Male & Female seq)*/
/*If LIM is negative,  only show a single result for the abs(lim) entry.*/

parse arg lim .;     if lim=='' then lim=99;     aLim=abs(lim)
parse var lim . hm. hf. Js Fs Ms;    hm.0=0;     hf.0=1

                do j=0 to Alim;               ff=F(j);           mm=M(j)
                      Js=Js jW(j);     Fs=Fs jw(ff);      Ms=Ms jW(mm)
                end

if lim>0  then  say 'Js='  Js;    else  say  'J('aLim")="  word(Js,aLim+1)
if lim>0  then  say 'Fs='  Fs;    else  say  'F('aLim")="  word(Fs,aLim+1)
if lim>0  then  say 'Ms='  Ms;    else  say  'M('aLim")="  word(Ms,aLim+1)
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────F, M, Jw  subroutines────────────*/
F:  procedure expose hm. hf.; arg n; if hf.n=='' then hf.n=n-M(F(n-1)); return hf.n
M:  procedure expose hm. hf.; arg n; if hm.n=='' then hm.n=n-F(M(n-1)); return hm.n
Jw: return right(arg(1),length(lim))   /*right justifies # for nice look*/
