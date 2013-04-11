/*REXX program shows mutual recursion (via Hofstadter Male & Female seq)*/
arg lim .;if lim=='' then lim=99; hm.=; hm.0=0; hf.=; hf.0=1; Js=; Fs=; Ms=

                do j=0 to lim;                   ff=F(j);         mm=M(j)
                         Js=Js jW(j);   Fs=Fs jw(ff);    Ms=Ms jW(mm)
                end   /*j*/
say 'Js=' Js
say 'Fs=' Fs
say 'Ms=' Ms
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────F, M, Jw  subroutines────────────*/
F:  procedure expose hm. hf.; arg n; if hf.n=='' then hf.n=n-M(F(n-1)); return hf.n
M:  procedure expose hm. hf.; arg n; if hm.n=='' then hm.n=n-F(M(n-1)); return hm.n
Jw: return right(arg(1),length(lim))   /*right justifies # for nice look*/
