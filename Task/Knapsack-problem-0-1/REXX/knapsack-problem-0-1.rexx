/*REXX pgm solves a knapsack problem (22 items with weight restriction).*/
@.=;                       @.1  = 'map                       9  150'
                           @.2  = 'compass                  13   35'
                           @.3  = 'water                   153  200'
                           @.4  = 'sandwich                 50  160'
                           @.5  = 'glucose                  15   60'
                           @.6  = 'tin                      68   45'
                           @.7  = 'banana                   27   60'
                           @.8  = 'apple                    39   40'
                           @.9  = 'cheese                   23   30'
                           @.10 = 'beer                     52   10'
                           @.11 = 'suntan_cream             11   70'
                           @.12 = 'camera                   32   30'
                           @.13 = 'T-shirt                  24   15'
                           @.14 = 'trousers                 48   10'
                           @.15 = 'umbrella                 73   40'
                           @.16 = 'waterproof_trousers      42   70'
                           @.17 = 'waterproof_overclothes   43   75'
                           @.18 = 'note-case                22   80'
                           @.19 = 'sunglasses                7   20'
                           @.20 = 'towel                    18   12'
                           @.21 = 'socks                     4   50'
                           @.22 = 'book                     30   10'
maxWeight=400                          /*the maximum weight for knapsack*/
say;  say 'maximum weight allowed for a knapsack:' comma(maxWeight);  say
maxL=length('item')                    /*maximum width for table names. */
maxL=length('knapsack items')          /*maximum width for table names. */
maxW=length('weight')                  /*   "      "    "    "   weights*/
maxV=length('value')                   /*   "      "    "    "   values.*/
maxQ=length('pieces')                  /*   "      "    "    "   quant. */
highQ=0                                /*max quantity specified (if any)*/
items=0; i.=; w.=0; v.=0; q.=0; Tw=0; Tv=0; Tq=0     /*initialize stuff.*/
/*────────────────────────────────sort the choices by decreasing weight.*/
                                       /*this minimizes # combinations. */
         do j=1  while @.j\==''        /*process each choice and sort.  */
         _=@.j;     _wt=word(_,2)      /*choose first item (arbitrary). */
         _wt=word(_,2)
              do k=j+1  while @.k\=='' /*find a possible heavier item.  */
              ?wt=word(@.k,2)
              if ?wt>_wt then do;  _=@.k;  @.k=@.j;  @.j=_;  _wt=?wt;  end
              end   /*k*/
         end        /*j*/
obj=j-1                                /*adjust for the DO loop index.  */
/*────────────────────────────────build list of choices.────────────────*/
      do j=1  for obj                  /*build a list of choices.       */
      _=space(@.j)                     /*remove superfluous blanks.     */
      parse var _ item w v q .         /*parse original choice for table*/
      if w>maxWeight then iterate      /*if the weight > maximum, ignore*/
      Tw=Tw+w;  Tv=Tv+v;  Tq=Tq+1      /*add totals up (for alignment). */
      maxL=max(maxL,length(item))      /*find maximum width for item.   */
      if q=='' then q=1
      highQ=max(highQ,q)
      items=items+1                    /*bump the item counter.         */
      i.items=item;  w.items=w;  v.items=v;  q.items=q
           do k=2  to q; items=items+1 /*bump the item counter.         */
           i.items=item;  w.items=w;  v.items=v;  q.items=q
                          Tw=Tw+w;    Tv=Tv+v;    Tq=Tq+1
           end   /*k*/
      end        /*j*/

maxW=max(maxW,length(comma(Tw)))       /*find maximum width for weight. */
maxV=max(maxV,length(comma(Tv)))       /*  "     "      "    "  value.  */
maxQ=max(maxQ,length(comma(Tq)))       /*  "     "      "    "  quantity*/
maxL=maxL+maxL%4+4                     /*extend width of name for table.*/
/*────────────────────────────────show the list of choices.─────────────*/
call hdr 'item';    do j=1  for obj    /*show all choices, nice format. */
                    parse var @.j item weight value q .
                    if highq==1  then  q=
                                 else  if q==''  then q=1
                    call show item,weight,value,q
                    end   /*j*/

say;    say 'number of items:' items;    say
/*─────────────────────────────────────examine all the possible choices.*/
h=items;   ho=h+1;   m=maxWeight;   $=0;   call sim22
/*─────────────────────────────────────show the best choice (weight,val)*/
                              do h-1;    ?=strip(strip(?),"L",0);    end
bestC=?;   bestW=0;   bestV=$;   highQ=0;   totP=words(bestC)
call hdr 'best choice'
                      do j=1  to totP  /*J  is modified within DO loop. */
                      _=word(bestC,j);  _w=w._;  _v=v._;  q=1
                      if _==0  then iterate
                          do k=j+1  to totP
                          __=word(bestC,k);       if i._\==i.__ then leave
                          j=j+1;   w._=w._+_w;    v._=v._+_v;   q=q+1
                          end    /*k*/
                      call show i._,w._,v._,q;    bestW=bestw+w._
                      end         /*j*/
call hdr2;  say
call show 'best weight'   ,bestW       /*show a nicely formatted winnerW*/
call show 'best value'    ,,bestV      /*show a nicely formatted winnerV*/
call show 'knapsack items',,,totP      /*show a nicely formatted pieces.*/
exit                                   /*stick a fork in it, we're done.*/
/*────────────────────────────────COMMA subroutine───────────────────────────────────────────────*/
comma: procedure; parse arg _,c,p,t;arg ,cu;c=word(c ",",1);if cu=='BLANK' then c=' ';o=word(p 3,1)
k=0;p=abs(o);t=word(t 999999999,1);if \datatype(p,'W')|\datatype(t,'W')|p==0|arg()>4 then return _
n=_'.9'; #=123456789; if o<0  then do;  b=verify(_,' ');  if b==0  then return _
e=length(_)-verify(reverse(_),' ')+1;  end;     else  do;  b=verify(n,#,"M")
e=verify(n,#'0',,verify(n,#"0.",'M'))-p-1;end;do j=e to b by -p while k<t;_=insert(c,_,j);k=k+1;end
return _                               /* [↑]  adds commas to the 1st number found in the string.*/
/*────────────────────────────────HDR subroutine─────────────────────────────────────────────────*/
hdr:  parse arg _item_,_;       if highq\==1  then _=center('pieces',maxq)
call show center(_item_ ,maxL),  center('weight',maxW),  center('value',maxV),  center(_,maxQ)
call hdr2;  return
/*────────────────────────────────HDR2 subroutine────────────────────────────────────────────────*/
hdr2: _=maxQ;    if highq==1  then _=0
call show copies('=',maxL),copies('=',maxW),copies('=',maxV),copies('=',_)
return
/*────────────────────────────────J? subroutine────────────────────────────────────────*/
j?: parse arg _,?; $=value('V'_);   do j=1  for _;   ?=? value('J'j);   end;       return
/*────────────────────────────────SHOW subroutine───────────────────────*/
show:  parse arg _item,_weight,_value,_quant
       say translate(left(_item,maxL,'─'),,'_'),
                     right(comma(_weight),maxW),
                     right(comma(_value ),maxV),
                     right(comma(_quant ),maxQ)
return
/*────────────────────────────────SIM22 subroutine───────────────────────────────────────────────────────────*/
sim22: do j1=0 for h+1;                                    w1=w.j1;      v1 =    v.j1; if v1>$  then call j?  1
 do j2 =j1 +(j1 \==0) to h;if w.j2 +w1>m  then iterate j1; w2 =w1 +w.j2; v2 =v1 +v.j2; if v2>$  then call j?  2
 do j3 =j2 +(j2 \==0) to h;if w.j3 +w2>m  then iterate j2; w3 =w2 +w.j3; v3 =v2 +v.j3; if v3>$  then call j?  3
 do j4 =j3 +(j3 \==0) to h;if w.j4 +w3>m  then iterate j3; w4 =w3 +w.j4; v4 =v3 +v.j4; if v4>$  then call j?  4
 do j5 =j4 +(j4 \==0) to h;if w.j5 +w4>m  then iterate j4; w5 =w4 +w.j5; v5 =v4 +v.j5; if v5>$  then call j?  5
 do j6 =j5 +(j5 \==0) to h;if w.j6 +w5>m  then iterate j5; w6 =w5 +w.j6; v6 =v5 +v.j6; if v6>$  then call j?  6
 do j7 =j6 +(j6 \==0) to h;if w.j7 +w6>m  then iterate j6; w7 =w6 +w.j7; v7 =v6 +v.j7; if v7>$  then call j?  7
 do j8 =j7 +(j7 \==0) to h;if w.j8 +w7>m  then iterate j7; w8 =w7 +w.j8; v8 =v7 +v.j8; if v8>$  then call j?  8
 do j9 =j8 +(j8 \==0) to h;if w.j9 +w8>m  then iterate j8; w9 =w8 +w.j9; v9 =v8 +v.j9; if v9>$  then call j?  9
 do j10=j9 +(j9 \==0) to h;if w.j10+w9>m  then iterate j9; w10=w9 +w.j10;v10=v9 +v.j10;if v10>$ then call j? 10
 do j11=j10+(j10\==0) to h;if w.j11+w10>m then iterate j10;w11=w10+w.j11;v11=v10+v.j11;if v11>$ then call j? 11
 do j12=j11+(j11\==0) to h;if w.j12+w11>m then iterate j11;w12=w11+w.j12;v12=v11+v.j12;if v12>$ then call j? 12
 do j13=j12+(j12\==0) to h;if w.j13+w12>m then iterate j12;w13=w12+w.j13;v13=v12+v.j13;if v13>$ then call j? 13
 do j14=j13+(j13\==0) to h;if w.j14+w13>m then iterate j13;w14=w13+w.j14;v14=v13+v.j14;if v14>$ then call j? 14
 do j15=j14+(j14\==0) to h;if w.j15+w14>m then iterate j14;w15=w14+w.j15;v15=v14+v.j15;if v15>$ then call j? 15
 do j16=j15+(j15\==0) to h;if w.j16+w15>m then iterate j15;w16=w15+w.j16;v16=v15+v.j16;if v16>$ then call j? 16
 do j17=j16+(j16\==0) to h;if w.j17+w16>m then iterate j16;w17=w16+w.j17;v17=v16+v.j17;if v17>$ then call j? 17
 do j18=j17+(j17\==0) to h;if w.j18+w17>m then iterate j17;w18=w17+w.j18;v18=v17+v.j18;if v18>$ then call j? 18
 do j19=j18+(j18\==0) to h;if w.j19+w18>m then iterate j18;w19=w18+w.j19;v19=v18+v.j19;if v19>$ then call j? 19
 do j20=j19+(j19\==0) to h;if w.j20+w19>m then iterate j19;w20=w19+w.j20;v20=v19+v.j20;if v20>$ then call j? 20
 do j21=j20+(j20\==0) to h;if w.j21+w20>m then iterate j20;w21=w20+w.j21;v21=v20+v.j21;if v21>$ then call j? 21
 do j22=j21+(j21\==0) to h;if w.j22+w21>m then iterate j21;w22=w21+w.j22;v22=v21+v.j22;if v22>$ then call j? 22
 end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end; end
return
