/*REXX program counts the  occurrences  of a (non─overlapping)  substring  in a string. */
w=.                                                                 /*max. width so far.*/
bag= 'the three truths'    ;      x= "th"       ;        call showResult
bag= 'ababababab'          ;      x= "abab"     ;        call showResult
bag= 'aaaabacad'           ;      x= "aa"       ;        call showResult
bag= 'abaabba*bbaba*bbab'  ;      x= "a*b"      ;        call showResult
bag= 'abaabba*bbaba*bbab'  ;      x= " "        ;        call showResult
bag=                       ;      x= "a"        ;        call showResult
bag=                       ;      x=            ;        call showResult
bag= 'catapultcatalog'     ;      x= "cat"      ;        call showResult
bag= 'aaaaaaaaaaaaaa'      ;      x= "aa"       ;        call showResult
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
countstr:   procedure;  parse arg haystack,needle,start;      if start==''  then start=1
            width=length(needle)
                                  do $=0  until p==0;         p=pos(needle,haystack,start)
                                  start=width + p                    /*prevent overlaps.*/
                                  end   /*$*/
            return $                                                 /*return the count.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
showResult: if w==. then do;                   w=30        /*W:  largest haystack width.*/
                         say center('haystack',w)  center('needle',w%2)  center('count',5)
                         say left('', w, "═")      left('', w%2, "═")    left('', 5, "═")
                         end

            if bag==''  then bag= " (null)"                /*handle displaying of nulls.*/
            if   x==''  then   x= " (null)"                /*   "        "      "   "   */
            say left(bag, w)           left(x, w%2)            center(countstr(bag, x), 5)
            return
