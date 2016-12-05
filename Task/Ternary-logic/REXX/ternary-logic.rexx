/*REXX program displays a ternary truth table  [true, false, maybe]   for the variables */
/*──── and one or more expressions.                                                     */
/*──── Infix notation is supported with one character propositional constants.          */
/*──── Variables (propositional constants) allowed:    A ──► Z,     a ──► z   except  u.*/
/*──── All propositional constants are case insensative  (except lowercase  v).         */
parse arg $express                               /*obtain optional argument from the CL.*/
if $express\=''  then do                         /*Got one?  Then show user's expression*/
                      call truthTable $express   /*display the user's truth table──►term*/
                      exit                       /*we're all done with the truth table. */
                      end

call truthTable  "a & b ; AND"
call truthTable  "a | b ; OR"
call truthTable  "a ^ b ; XOR"
call truthTable  "a ! b ; NOR"
call truthTable  "a ¡ b ; NAND"
call truthTable  "a xnor b ; XNOR"               /*XNOR  is the same as  NXOR.          */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
truthTable: procedure; parse arg $ ';' comm 1 $o;        $o=strip($o)
      $=translate(strip($), '|', "v");                   $u=$;        upper $u
      $u=translate($u, '()()()', "[]{}«»");              $$.=0;       PCs=;        hdrPCs=
      @abc= 'abcdefghijklmnopqrstuvwxyz';                @abcU=@abc;  upper @abcU
      @= 'ff'x                                         /*─────────infix operators───────*/
      op.=                                             /*a single quote (') wasn't      */
                                                       /*     implemented for negation. */
      op.0  = 'false  boolFALSE'                       /*unconditionally  FALSE         */
      op.1  = 'and    and & *'                         /* AND, conjunction              */
      op.2  = 'naimpb NaIMPb'                          /*not A implies B                */
      op.3  = 'boolb  boolB'                           /*B  (value of)                  */
      op.4  = 'nbimpa NbIMPa'                          /*not B implies A                */
      op.5  = 'boola  boolA'                           /*A  (value of)                  */
      op.6  = 'xor    xor && % ^'                      /* XOR, exclusive OR             */
      op.7  = 'or     or | + v'                        /*  OR, disjunction              */
      op.8  = 'nor    nor ! ↓'                         /* NOR, not OR, Pierce operator  */
      op.9  = 'xnor   xnor nxor'                       /*NXOR, not exclusive OR, not XOR*/
      op.10 = 'notb   notB'                            /*not B (value of)               */
      op.11 = 'bimpa  bIMPa'                           /*    B implies A                */
      op.12 = 'nota   notA'                            /*not A (value of)               */
      op.13 = 'aimpb  aIMPb'                           /*    A implies B                */
      op.14 = 'nand   nand ¡ ↑'                        /*NAND, not AND, Sheffer operator*/
      op.15 = 'true   boolTRUE'                        /*unconditionally   TRUE         */
                                                       /*alphabetic names need changing.*/
      op.16 = '\   NOT ~ ─ . ¬'                        /* NOT, negation                 */
      op.17 = '>   GT'                                 /*conditional greater than       */
      op.18 = '>=  GE ─> => ──> ==>' "1a"x             /*conditional greater than or eq.*/
      op.19 = '<   LT'                                 /*conditional less than          */
      op.20 = '<=  LE <─ <= <── <=='                   /*conditional less then or equal */
      op.21 = '\=  NE ~= ─= .= ¬='                     /*conditional not equal to       */
      op.22 = '=   EQ EQUAL EQUALS =' "1b"x            /*biconditional  (equals)        */
      op.23 = '0   boolTRUE'                           /*TRUEness                       */
      op.24 = '1   boolFALSE'                          /*FALSEness                      */

      op.25 = 'NOT NOT NEG'                            /*not, neg  (negative)           */

        do jj=0  while  op.jj\=='' | jj<16             /*change opers──►what REXX likes.*/
        new=word(op.jj,1)
          do kk=2  to words(op.jj)                     /*handle each token separately.  */
          _=word(op.jj, kk);     upper _
          if wordpos(_, $u)==0   then iterate          /*no such animal in this string. */
          if datatype(new, 'm')  then new!=@           /*expresion needs transcribing.  */
                                 else new!=new
          $u=changestr(_, $u, new!)                    /*transcribe the function (maybe)*/
          if new!==@  then $u=changeFunc($u, @, new)   /*use the internal boolean name. */
          end   /*kk*/
        end     /*jj*/

      $u=translate($u, '()', "{}")                     /*finish cleaning up transcribing*/
            do jj=1  for length(@abcU)                 /*see what variables are used.   */
            _=substr(@abcU, jj, 1)                     /*use available upercase alphabet*/
            if pos(_,$u)==0  then iterate              /*found one?   No, keep looking. */
            $$.jj=2                                    /*found:  set upper bound for it.*/
            PCs=PCs _                                  /*also, add to propositional cons*/
            hdrPCs=hdrPCS  center(_, length('false'))  /*build a propositional cons hdr.*/
            end   /*jj*/
      $u=PCs  '('$u")"                                 /*sep prop. cons. from expression*/
      ptr='_────►_'                                    /*a pointer for the truth table. */
      hdrPCs=substr(hdrPCs,2)                          /*create a header for prop. cons.*/
      say hdrPCs left('', length(ptr) -1)   $o         /*show prop cons hdr +expression.*/
      say copies('───── ', words(PCs))   left('', length(ptr)-2)   copies('─', length($o))
                                                       /*Note: "true"s:  right─justified*/
              do a=0  to $$.1
               do b=0  to $$.2
                do c=0  to $$.3
                 do d=0  to $$.4
                  do e=0  to $$.5
                   do f=0  to $$.6
                    do g=0  to $$.7
                     do h=0  to $$.8
                      do i=0  to $$.9
                       do j=0  to $$.10
                        do k=0  to $$.11
                         do l=0  to $$.12
                          do m=0  to $$.13
                           do n=0  to $$.14
                            do o=0  to $$.15
                             do p=0  to $$.16
                              do q=0  to $$.17
                               do r=0  to $$.18
                                do s=0  to $$.19
                                 do t=0  to $$.20
                                  do u=0  to $$.21
                                   do !=0  to $$.22
                                    do w=0  to $$.23
                                     do x=0  to $$.24
                                      do y=0  to $$.25
                                       do z=0  to $$.26
                                       interpret '_=' $u             /*evaluate truth T.*/
                                       _=changestr(0, _, 'false')    /*convert 0──►false*/
                                       _=changestr(1, _, '_true')    /*convert 1──►_true*/
                                       _=changestr(2, _, 'maybe')    /*convert 2──►maybe*/
                                       _=insert(ptr, _, wordindex(_, words(_)) -1) /*──►*/
                                       say translate(_, , '_')       /*display truth tab*/
                                       end   /*z*/
                                      end    /*y*/
                                     end     /*x*/
                                    end      /*w*/
                                   end       /*v*/
                                  end        /*u*/
                                 end         /*t*/
                                end          /*s*/
                               end           /*r*/
                              end            /*q*/
                             end             /*p*/
                            end              /*o*/
                           end               /*n*/
                          end                /*m*/
                         end                 /*l*/
                        end                  /*k*/
                       end                   /*j*/
                      end                    /*i*/
                     end                     /*h*/
                    end                      /*g*/
                   end                       /*f*/
                  end                        /*e*/
                 end                         /*d*/
                end                          /*c*/
               end                           /*b*/
              end                            /*a*/
      say
      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
scan: procedure; parse arg x,at;    L=length(x);    t=L;     lp=0;     apost=0;    quote=0
      if at<0  then do;  t=1;  x=translate(x, '()', ")(");   end

                      do j=abs(at)  to t  by sign(at);  _=substr(x,j,1);  __=substr(x,j,2)
                      if quote           then do; if _\=='"'  then iterate
                                              if __=='""'     then do; j=j+1; iterate; end
                                              quote=0;  iterate
                                              end
                      if apost           then do; if _\=="'"  then iterate
                                              if __=="''"     then do; j=j+1; iterate; end
                                              apost=0;  iterate
                                              end
                      if _=='"'          then do; quote=1;                    iterate; end
                      if _=="'"          then do; apost=1;                    iterate; end
                      if _==' '          then iterate
                      if _=='('          then do; lp=lp+1;                    iterate; end
                      if lp\==0          then do; if _==')'   then lp=lp-1;   iterate; end
                      if datatype(_,'U') then return j - (at<0)
                      if at<0            then return j + 1
                      end   /*j*/
      return min(j,L)
/*──────────────────────────────────────────────────────────────────────────────────────*/
changeFunc: procedure;  parse arg z,fC,newF;   funcPos=0
           do forever
           funcPos=pos(fC, z, funcPos + 1);    if funcPos==0  then return z
           origPos=funcPos
           z=changestr(fC, z, ",'"newF"',")
           funcPos=funcPos + length(newF) + 4
           where=scan(z, funcPos)     ;        z=insert(    '}',  z,  where)
           where=scan(z, 1 - origPos) ;        z=insert('trit{',  z,  where)
           end   /*forever*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
trit: procedure; arg a,$,b;    v=\(a==2 | b==2);      o= a==1 | b==1;       z= a==0 | b==0
           select
           when $=='FALSE'   then           return 0
           when $=='AND'     then if v then return a & b;      else return 2
           when $=='NAIMPB'  then if v then return \(\a & \b); else return 2
           when $=='BOOLB'   then           return b
           when $=='NBIMPA'  then if v then return \(\b & \a); else return 2
           when $=='BOOLA'   then           return a
           when $=='XOR'     then if v then return a && b    ; else return 2
           when $=='OR'      then if v then return a | b     ; else  if o  then return 1
                                                                           else return 2
           when $=='NOR'     then if v then return \(a | b)  ; else return 2
           when $=='XNOR'    then if v then return \(a && b) ; else return 2
           when $=='NOTB'    then if v then return \b        ; else return 2
           when $=='NOTA'    then if v then return \a        ; else return 2
           when $=='AIMPB'   then if v then return \(a & \b) ; else return 2
           when $=='NAND'    then if v then return \(a &  b) ; else  if z  then return 1
                                                                           else return 2
           when $=='TRUE'    then           return   1
           otherwise                        return -13        /*error, unknown function.*/
           end   /*select*/
