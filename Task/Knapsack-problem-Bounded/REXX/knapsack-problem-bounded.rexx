/*REXX pgm solves a knapsack problem (22 items + repeats, weight restriction. */
call @gen                              /*generate items and initializations.  */
call @sort                             /*sort items by decreasing their weight*/
call bOBJ                              /*build a list of choices (objects).   */
call showOBJ                           /*display the list of choices (objects)*/
call sim37                             /*examine and find the possible choices*/
call showBest                          /*display best choice  (weight, value).*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────@GEN subroutine─────────────────────────────*/
@gen: @.=;        @.1  = 'map                       9  150'
                  @.2  = 'compass                  13   35'
                  @.3  = 'water                   153  200   2'
                  @.4  = 'sandwich                 50   60   2'
                  @.5  = 'glucose                  15   60   2'
                  @.6  = 'tin                      68   45   3'
                  @.7  = 'banana                   27   60   3'
                  @.8  = 'apple                    39   40   3'
                  @.9  = 'cheese                   23   30'
                  @.10 = 'beer                     52   10   3'
                  @.11 = 'suntan_cream             11   70'
                  @.12 = 'camera                   32   30'
                  @.13 = 'T-shirt                  24   15   2'
                  @.14 = 'trousers                 48   10   2'
                  @.15 = 'umbrella                 73   40'
                  @.16 = 'waterproof_trousers      42   70'
                  @.17 = 'waterproof_overclothes   43   75'
                  @.18 = 'note-case                22   80'
                  @.19 = 'sunglasses                7   20'
                  @.20 = 'towel                    18   12   2'
                  @.21 = 'socks                     4   50'
                  @.22 = 'book                     30   10   2'
highQ=0                                /*maximum quantity specified (if any). */
maxWeight=400                          /*the maximum weight for the knapsack. */
maxL=length('knapsack items')          /* "     "    width for the table names*/
maxW=length('weight')                  /* "     "      "    "    "   weights. */
maxV=length('value')                   /* "     "      "    "    "   values.  */
maxQ=length('pieces')                  /* "     "      "    "    "   quantity.*/
items=0;  i.=;  w.=0;  v.=0;  q.=0     /*initialize some stuff and things.    */
Tw=0; Tv=0; Tq=0;      m=maxWeight     /*     "     more   "    "     "       */
say;  say 'maximum weight allowed for a knapsack: '   commas(maxWeight);     say
return
/*────────────────────────────────@SORT subroutine────────────────────────────*/
@sort:   do j=1  while  @.j\==''       /*process each choice and sort the item*/
         _=space(@.j);  @.j=_          /*remove any superfluous blanks.       */
         _wt=word(_, 2)                /*choose first item (arbitrary).       */
             do k=j+1  while @.k\==''  /*find a possible heavier item.        */
             ?wt=word(@.k, 2)
             if ?wt>_wt  then do;  _=@.k;  @.k=@.j;  @.j=_;  _wt=?wt;  end
             end   /*k*/
         end       /*j*/               /* [↑]  minimizes the # of combinations*/
obj=j-1                                /*adjust for the   DO   loop index.    */
return
/*────────────────────────────────BOBJ subroutine─────────────────────────────*/
bOBJ: do j=1  for obj                  /*build a list of choices (objects).   */
      parse var  @.j  item  w  v  q  . /*parse the original choice for table. */
      if w>maxWeight  then iterate     /*Is the weight > maximum?  Then ignore*/
      Tw=Tw+w;  Tv=Tv+v;   Tq=Tq+1     /*add the totals up  (for alignment).  */
      maxL=max(maxL, length(item))     /*find the maximum width for an item.  */
      if q==''  then q=1
      highQ=max(highQ, q)
      items=items+1                    /*bump the item counter.               */
      i.items=item;  w.items=w;  v.items=v;  q.items=q
          do k=2  to q;  items=items+1 /*bump the item counter  (each piece). */
          i.items=item;  w.items=w;  v.items=v;  q.items=q
                         Tw=Tw+w;    Tv=Tv+v;    Tq=Tq+1
          end   /*k*/
      end       /*j*/

maxW=max(maxW, length(commas(Tw)))     /*find the maximum width for weight.   */
maxV=max(maxV, length(commas(Tv)))     /*  "   "     "      "    "  value.    */
maxQ=max(maxQ, length(commas(Tq)))     /*  "   "     "      "    "  quantity. */
maxL=maxL    +    maxL %4    +    4    /*extend the width of name for table.  */
return                                 /* [↑]    %  is REXX integer division. */
/*────────────────────────────────comma subroutine────────────────────────────*/
commas: procedure;  parse arg _;   n=_'.9';    #=123456789;    b=verify(n,#,"M")
        e=verify(n,#'0',,verify(n,#"0.",'M'))-4
           do j=e  to b  by -3;   _=insert(',',_,j);    end  /*j*/;     return _
/*────────────────────────────────HDR subroutine──────────────────────────────*/
hdr:  parse arg _item_, _;        if highq\==1  then _=center('pieces', maxq)
                                  call show center( _item_ , maxL),,
                                            center('weight', maxW),,
                                            center('value' , maxV),,
                                            center(_       , maxQ)
call hdr2;   return
/*────────────────────────────────HDR2 subroutine─────────────────────────────*/
hdr2:  _=maxQ;   if highq==1  then _=0;     call show copies('═'   ,maxL),,
                                                      copies('═'   ,maxW),,
                                                      copies('═'   ,maxV),,
                                                      copies('═'   ,_   )
return
/*────────────────────────────────J? subroutine──────────-────────────────────*/
j?: parse arg _,?; $=value('V'_);  do j=1  for _; ?=? value('J'j); end;   return
/*────────────────────────────────SHOW subroutine─────────────────────────────*/
show:  parse arg _item, _weight, _value, _quant
                                     say translate(left(_item, maxL,'─'), ,'_'),
                                                   right(commas(_weight), maxW),
                                                   right(commas(_value ), maxV),
                                                   right(commas(_quant ), maxQ)
return
/*──────────────────────────────────SHOWOBJ subroutine────────────────────────*/
showOBJ: call hdr 'item';     do j=1  for obj   /*show the formatted choices. */
                              parse var  @.j  item weight value q .
                              if highq==1  then  q=
                                           else  if q==''  then q=1
                              call show  item, weight, value, q
                              end   /*j*/
say;    say  'number of items (with repetitions): '  items;    say
return
/*──────────────────────────────────SHOWBEST subroutine───────────────────────*/
showBest:                     do h-1;  ?=strip(strip(?), "L", 0);   end  /*h-1*/
bestC=?;   bestW=0;   bestV=$;   highQ=0;   totP=words(bestC);   say;   say
call hdr 'best choice'
                       do j=1  to totP       /*J  is modified within DO loop. */
                       _=word(bestC, j);     _w=w._;     _v=v._;     q=1
                       if _==0  then iterate
                           do k=j+1  to totP
                           __=word(bestC, k);        if i._\==i.__  then leave
                           j=j+1;   w._=w._+_w;      v._=v._+_v;    q=q+1
                           end   /*k*/
                       call show  i._,  w._,  v._,  q;           bestW=bestw+w._
                       end       /*j*/
call hdr2;  say
call show 'best weight'   ,     bestW        /*show a nicely formatted winnerW*/
call show 'best value'    , ,   bestV        /*  "  "    "       "     winnerV*/
call show 'knapsack items', , , totP         /*  "  "    "       "     pieces.*/
return
/*─────────────────────────────────────SIM37 subroutine──────────────────────────────────────────────────────────────────────────────────────────*/
sim37: h=items;      $=0
                    do j1 =0 for h+1;                                             w1=    w.j1 ;  v1=    v.j1 ; if  v1>$  then call j?  1
                    do j2 =j1 +(j1 \==0) to h; if w.j2 +w1 >m  then iterate  j1;  w2=w1 +w.j2 ;  v2=v1 +v.j2 ; if  v2>$  then call j?  2
                    do j3 =j2 +(j2 \==0) to h; if w.j3 +w2 >m  then iterate  j2;  w3=w2 +w.j3 ;  v3=v2 +v.j3 ; if  v3>$  then call j?  3
                    do j4 =j3 +(j3 \==0) to h; if w.j4 +w3 >m  then iterate  j3;  w4=w3 +w.j4 ;  v4=v3 +v.j4 ; if  v4>$  then call j?  4
                    do j5 =j4 +(j4 \==0) to h; if w.j5 +w4 >m  then iterate  j4;  w5=w4 +w.j5 ;  v5=v4 +v.j5 ; if  v5>$  then call j?  5
                    do j6 =j5 +(j5 \==0) to h; if w.j6 +w5 >m  then iterate  j5;  w6=w5 +w.j6 ;  v6=v5 +v.j6 ; if  v6>$  then call j?  6
                    do j7 =j6 +(j6 \==0) to h; if w.j7 +w6 >m  then iterate  j6;  w7=w6 +w.j7 ;  v7=v6 +v.j7 ; if  v7>$  then call j?  7
                    do j8 =j7 +(j7 \==0) to h; if w.j8 +w7 >m  then iterate  j7;  w8=w7 +w.j8 ;  v8=v7 +v.j8 ; if  v8>$  then call j?  8
                    do j9 =j8 +(j8 \==0) to h; if w.j9 +w8 >m  then iterate  j8;  w9=w8 +w.j9 ;  v9=v8 +v.j9 ; if  v9>$  then call j?  9
                    do j10=j9 +(j9 \==0) to h; if w.j10+w9 >m  then iterate  j9; w10=w9 +w.j10; v10=v9 +v.j10; if v10>$  then call j? 10
                    do j11=j10+(j10\==0) to h; if w.j11+w10>m  then iterate j10; w11=w10+w.j11; v11=v10+v.j11; if v11>$  then call j? 11
                    do j12=j11+(j11\==0) to h; if w.j12+w11>m  then iterate j11; w12=w11+w.j12; v12=v11+v.j12; if v12>$  then call j? 12
                    do j13=j12+(j12\==0) to h; if w.j13+w12>m  then iterate j12; w13=w12+w.j13; v13=v12+v.j13; if v13>$  then call j? 13
                    do j14=j13+(j13\==0) to h; if w.j14+w13>m  then iterate j13; w14=w13+w.j14; v14=v13+v.j14; if v14>$  then call j? 14
                    do j15=j14+(j14\==0) to h; if w.j15+w14>m  then iterate j14; w15=w14+w.j15; v15=v14+v.j15; if v15>$  then call j? 15
                    do j16=j15+(j15\==0) to h; if w.j16+w15>m  then iterate j15; w16=w15+w.j16; v16=v15+v.j16; if v16>$  then call j? 16
                    do j17=j16+(j16\==0) to h; if w.j17+w16>m  then iterate j16; w17=w16+w.j17; v17=v16+v.j17; if v17>$  then call j? 17
                    do j18=j17+(j17\==0) to h; if w.j18+w17>m  then iterate j17; w18=w17+w.j18; v18=v17+v.j18; if v18>$  then call j? 18
                    do j19=j18+(j18\==0) to h; if w.j19+w18>m  then iterate j18; w19=w18+w.j19; v19=v18+v.j19; if v19>$  then call j? 19
                    do j20=j19+(j19\==0) to h; if w.j20+w19>m  then iterate j19; w20=w19+w.j20; v20=v19+v.j20; if v20>$  then call j? 20
                    do j21=j20+(j20\==0) to h; if w.j21+w20>m  then iterate j20; w21=w20+w.j21; v21=v20+v.j21; if v21>$  then call j? 21
                    do j22=j21+(j21\==0) to h; if w.j22+w21>m  then iterate j21; w22=w21+w.j22; v22=v21+v.j22; if v22>$  then call j? 22
                    do j23=j22+(j22\==0) to h; if w.j23+w22>m  then iterate j22; w23=w22+w.j23; v23=v22+v.j23; if v23>$  then call j? 23
                    do j24=j23+(j23\==0) to h; if w.j24+w23>m  then iterate j23; w24=w23+w.j24; v24=v23+v.j24; if v24>$  then call j? 24
                    do j25=j24+(j24\==0) to h; if w.j25+w24>m  then iterate j24; w25=w24+w.j25; v25=v24+v.j25; if v25>$  then call j? 25
                    do j26=j25+(j25\==0) to h; if w.j26+w25>m  then iterate j25; w26=w25+w.j26; v26=v25+v.j26; if v26>$  then call j? 26
                    do j27=j26+(j26\==0) to h; if w.j27+w26>m  then iterate j26; w27=w26+w.j27; v27=v26+v.j27; if v27>$  then call j? 27
                    do j28=j27+(j27\==0) to h; if w.j28+w27>m  then iterate j27; w28=w27+w.j28; v28=v27+v.j28; if v28>$  then call j? 28
                    do j29=j28+(j28\==0) to h; if w.j29+w28>m  then iterate j28; w29=w28+w.j29; v29=v28+v.j29; if v29>$  then call j? 29
                    do j30=j29+(j29\==0) to h; if w.j30+w29>m  then iterate j29; w30=w29+w.j30; v30=v29+v.j30; if v30>$  then call j? 30
                    do j31=j30+(j30\==0) to h; if w.j31+w30>m  then iterate j30; w31=w30+w.j31; v31=v30+v.j31; if v31>$  then call j? 31
                    do j32=j31+(j31\==0) to h; if w.j32+w31>m  then iterate j31; w32=w31+w.j32; v32=v31+v.j32; if v32>$  then call j? 32
                    do j33=j32+(j32\==0) to h; if w.j33+w32>m  then iterate j32; w33=w32+w.j33; v33=v32+v.j33; if v33>$  then call j? 33
                    do j34=j33+(j33\==0) to h; if w.j34+w33>m  then iterate j33; w34=w33+w.j34; v34=v33+v.j34; if v34>$  then call j? 34
                    do j35=j34+(j34\==0) to h; if w.j35+w34>m  then iterate j34; w35=w34+w.j35; v35=v34+v.j35; if v35>$  then call j? 35
                    do j36=j35+(j35\==0) to h; if w.j36+w35>m  then iterate j35; w36=w35+w.j36; v36=v35+v.j36; if v36>$  then call j? 36
                    do j37=j36+(j36\==0) to h; if w.j37+w36>m  then iterate j36; w37=w36+w.j37; v37=v36+v.j37; if v37>$  then call j? 37
end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end
return              /* [↑]  there is one   END   for each of the   DO  loops. */
