/*REXX pgm displays top 10 words in a file (includes foreign letters),  case is ignored.*/
parse arg fID top .                              /*obtain optional arguments from the CL*/
if fID=='' | fID==","  then fID= 'les_mes.txt'   /*None specified? Then use the default.*/
if top=='' | top==","  then top= 10              /*  "      "        "   "   "     "    */
call init                                        /*initialize varied bunch of variables.*/
call rdr
say right('word', 40)  " "  center(' rank ', 6)  "  count "   /*display title for output*/
say right('════', 40)  " "  center('══════', 6)  " ═══════"   /*   "    title separator.*/

     do  until otops==tops | tops>top            /*process enough words to satisfy  TOP.*/
     WL=;         mk= 0;    otops= tops          /*initialize the word list (to a NULL).*/

          do n=1  for c;    z= !.n;      k= @.z  /*process the list of words in the file*/
          if k==mk  then WL= WL z                /*handle cases of tied number of words.*/
          if k> mk  then do;  mk=k;  WL=z;  end  /*this word count is the current max.  */
          end   /*n*/

     wr= max( length(' rank '), length(top) )    /*find the maximum length of the rank #*/

          do d=1  for words(WL);  y= word(WL, d) /*process all words in the  word list. */
          if d==1  then w= max(10, length(@.y) ) /*use length of the first number used. */
          say right(y, 40)         right( commas(tops), wr)          right(commas(@.y), w)
          @.y= .                                 /*nullify word count for next go 'round*/
          end   /*d*/                            /* [↑]  this allows a non-sorted list. */

     tops= tops + words(WL)                      /*correctly handle any  tied  rankings.*/
     end        /*until*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
16bit:  do k=1 for xs; _=word(x,k); $=changestr('├'left(_,1),$,right(_,1)); end;  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
init:   x= 'Çà åÅ çÇ êÉ ëÉ áà óâ ªæ ºç ¿è ⌐é ¬ê ½ë «î »ï ▒ñ ┤ô ╣ù ╗û ╝ü';     xs= words(x)
        abcL="abcdefghijklmnopqrstuvwxyz'"       /*lowercase letters of Latin alphabet. */
        abcU= abcL;            upper abcU        /*uppercase version of Latin alphabet. */
        accL= 'üéâÄàÅÇêëèïîìéæôÖòûùÿáíóúÑ'       /*some lowercase accented characters.  */
        accU= 'ÜéâäàåçêëèïîìÉÆôöòûùÿáíóúñ'       /*  "  uppercase    "         "        */
        accG= 'αßΓπΣσµτΦΘΩδφε'                   /*  "  upper/lowercase Greek letters.  */
        ll= abcL || abcL ||accL ||accL || accG               /*chars of  after letters. */
        uu= abcL || abcU ||accL ||accU || accG || xrange()   /*  "    " before    "     */
        @.= 0;    q= "'";    totW= 0;    !.= @.;    c= 0;    tops= 1;          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
rdr:   do #=0  while lines(fID)\==0; $=linein(fID) /*loop whilst there're lines in file.*/
       if pos('├', $) \== 0  then call 16bit       /*are there any  16-bit  characters ?*/
       $= translate( $, ll, uu)                    /*trans. uppercase letters to lower. */
          do while $ \= '';    parse var  $  z  $  /*process each word in the  $  line. */
          parse var  z     z1  2  zr  ''  -1  zL   /*obtain: first, middle, & last char.*/
          if z1==q  then do; z=zr; if z==''  then iterate; end /*starts with apostrophe?*/
          if zL==q  then z= strip(left(z, length(z) - 1))      /*ends     "       "    ?*/
          if z==''  then iterate                               /*if Z is now null, skip.*/
          if @.z==0  then do;  c=c+1; !.c=z;  end  /*bump word cnt; assign word to array*/
          totW= totW + 1;      @.z= @.z + 1        /*bump total words; bump a word count*/
          end   /*while*/
       end      /*#*/
    say commas(totW)     ' words found  ('commas(c)    "unique)  in "    commas(#),
                         ' records read from file: '     fID;        say;          return
