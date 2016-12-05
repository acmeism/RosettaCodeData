/*REXX program solves a knapsack problem (23 items with a weight restriction).*/
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
                           @.23 = 'anvil                  1000 1250'
maxWeight=400                          /*the maximum weight for the knapsack. */
say 'maximum weight allowed for a knapsack:'  commas(maxWeight);     say
pot_item= 'potential knapsack items'   /*the full name for the header title.  */
maxL=length(pot_item)                  /*maximum width for the table names.   */
maxW=length('weight')                  /*   "      "    "   "    "   weights. */
maxV=length('value')                   /*   "      "    "   "    "   values.  */
#=0;  i.=;  w.=0;  v.=0;  q.=0;  Tw=0;  Tv=0          /*initialize some stuff.*/
/*══════════════════════════════════════sort the choices by decreasing weight.*/
         do j=1  while @.j\==''        /*process each of the knapsack choices.*/
         _=space(@.j);  _wt=word(_, 2) /*choose the first item  (arbitrary).  */
              do k=j+1  while @.k\=='' /*find a possible heavier knapsack item*/
              ?wt=word(@.k, 2)
              if ?wt>_wt  then do;  _=@.k;  @.k=@.j;  @.j=_;  _wt=?wt;  end
              end   /*k*/
         end        /*j*/
obj=j-1                                /*decrement  J  for the  DO  loop index*/
/*══════════════════════════════════════build list of choices.════════════════*/
      do j=1  for obj                  /*construct a list of knapsack choices.*/
      parse var  @.j  item  w  v  .    /*parse the original choice for table. */
      if w>maxWeight then iterate      /*Is weight greater than max?   Ignore.*/
      Tw=Tw+w;   Tv=Tv+v               /*add the totals (for output alignment)*/
      maxL=max(maxL, length(item))     /*determine the maximum width for item.*/
      #=#+1;  i.#=item;  w.#=w;  v.#=v /*bump the number of items (choices).  */
      end   /*j*/

maxW=max(maxW,length(commas(Tw)))      /*find the maximum width for  weight.  */
maxV=max(maxV,length(commas(Tv)))      /*  "   "     "      "    "   value.   */
maxL=maxL + maxL%4 + 4                 /*extend the width of name for table.  */
/*══════════════════════════════════════show the list of choices.═════════════*/
call hdr pot_item;  do j=1  for obj    /*show all choices in a nice format.   */
                    parse  var  @.j   item  weight  value  .
                    call show item, weight, value
                    end   /*j*/
say
say 'number of allowable items: '   #  /* [↓]   examine all possible choices. */
$=0;                                     m=maxWeight
 do j1 =0  for #+1;                                          w1 =    w.j1; v1 =    v.j1
 do j2 =j1 +(j1 \==0) to #; if w.j2 +w1 >m then iterate j1 ; w2 =w1 +w.j2; v2 =v1 +v.j2
 do j3 =j2 +(j2 \==0) to #; if w.j3 +w2 >m then iterate j2 ; w3 =w2 +w.j3; v3 =v2 +v.j3
 do j4 =j3 +(j3 \==0) to #; if w.j4 +w3 >m then iterate j3 ; w4 =w3 +w.j4; v4 =v3 +v.j4
 do j5 =j4 +(j4 \==0) to #; if w.j5 +w4 >m then iterate j4 ; w5 =w4 +w.j5; v5 =v4 +v.j5
 do j6 =j5 +(j5 \==0) to #; if w.j6 +w5 >m then iterate j5 ; w6 =w5 +w.j6; v6 =v5 +v.j6
 do j7 =j6 +(j6 \==0) to #; if w.j7 +w6 >m then iterate j6 ; w7 =w6 +w.j7; v7 =v6 +v.j7
 do j8 =j7 +(j7 \==0) to #; if w.j8 +w7 >m then iterate j7 ; w8 =w7 +w.j8; v8 =v7 +v.j8
 do j9 =j8 +(j8 \==0) to #; if w.j9 +w8 >m then iterate j8 ; w9 =w8 +w.j9; v9 =v8 +v.j9
 do j10=j9 +(j9 \==0) to #; if w.j10+w9 >m then iterate j9 ; w10=w9 +w.j10;v10=v9 +v.j10
 do j11=j10+(j10\==0) to #; if w.j11+w10>m then iterate j10; w11=w10+w.j11;v11=v10+v.j11
 do j12=j11+(j11\==0) to #; if w.j12+w11>m then iterate j11; w12=w11+w.j12;v12=v11+v.j12
 do j13=j12+(j12\==0) to #; if w.j13+w12>m then iterate j12; w13=w12+w.j13;v13=v12+v.j13
 do j14=j13+(j13\==0) to #; if w.j14+w13>m then iterate j13; w14=w13+w.j14;v14=v13+v.j14
 do j15=j14+(j14\==0) to #; if w.j15+w14>m then iterate j14; w15=w14+w.j15;v15=v14+v.j15
 do j16=j15+(j15\==0) to #; if w.j16+w15>m then iterate j15; w16=w15+w.j16;v16=v15+v.j16
 do j17=j16+(j16\==0) to #; if w.j17+w16>m then iterate j16; w17=w16+w.j17;v17=v16+v.j17
 do j18=j17+(j17\==0) to #; if w.j18+w17>m then iterate j17; w18=w17+w.j18;v18=v17+v.j18
 do j19=j18+(j18\==0) to #; if w.j19+w18>m then iterate j18; w19=w18+w.j19;v19=v18+v.j19
 do j20=j19+(j19\==0) to #; if w.j20+w19>m then iterate j19; w20=w19+w.j20;v20=v19+v.j20
 do j21=j20+(j20\==0) to #; if w.j21+w20>m then iterate j20; w21=w20+w.j21;v21=v20+v.j21
 do j22=j21+(j21\==0) to #; if w.j22+w21>m then iterate j21; w22=w21+w.j22;v22=v21+v.j22
 if v22>$  then do; _=22; ?=; $=v22;   do j=1  for _;  ?=? value("J"j);   end /*j*/; end
 end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end;end

bestC=?;   bestW=0;   bestV=$;   totP=words(bestC);    say
call hdr 'best choice'
                       do j=1  for totP;  _=word(bestC, j);     _w=w._;   _v=v._
                       if _==0  then iterate
                           do k=j+1  to totP
                           __=word(bestC, k);     if i._\==i.__ then leave
                           j=j+1;   w._=w._+_w;   v._=v._+_v
                           end    /*k*/
                       call show i._,w._,v._;     bestW=bestw+w._
                       end        /*j*/
call hdr2; say;                                   @btk= 'best total knapsack'
call show @btk  'weight' ,   bestW     /*display a nicely formatted winnerW.  */
call show @btk  'value'  ,,  bestV     /*     "  "    "       "     winnerV.  */
call show @btk  'items'  ,,, totP      /*     "  "    "       "     pieces.   */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
commas: procedure;  parse arg _;   n=_'.9';  #=123456789;    b=verify(n, #, "M")
        e=verify(n, #'0', , verify(n, #"0.", 'M')) - 4
           do j=e  to b  by -3;   _=insert(',', _, j);   end  /*j*/;    return _
/*────────────────────────────────────────────────────────────────────────────*/
hdr:    call show center(arg(1),maxL),center('weight',maxW),center("value",maxV)
        call hdr2;  return
/*────────────────────────────────────────────────────────────────────────────*/
hdr2:   call show copies('═',maxL),copies('═',maxW),copies('═',maxV);     return
/*────────────────────────────────────────────────────────────────────────────*/
show:   parse arg _it,_wt,_val,_p;    say translate( left(_it, maxL, '─'),,"_"),
              right(commas(_wt),maxW) right(commas(_val),maxV) ' ' _p;    return
