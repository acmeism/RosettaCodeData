/*REXX program performs a  Burrows─Wheeler transform  (BWT)  on a character string(s).  */
$.=                                              /*the default text for (all) the inputs*/
parse arg $.1                                    /*obtain optional arguments from the CL*/
if $.1=''  then do;  $.1= "banana"               /*Not specified?  Then use the defaults*/
                     $.2= "BANANA"
                     $.3= "appellee"
                     $.4= "dogwood"
                     $.5= "TO BE OR NOT TO BE OR WANT TO BE OR NOT?"
                     $.6= "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES"
                     $.7= "^ABC|"
                     $.7= "bad─bad thingy"'fd'x  /* ◄─── this string can't be processed.*/
                end
                                                 /* [↑]  show blank line between outputs*/
       do t=1  while $.t\='';  if t\==1 then say /*process each of the inputs (or input)*/
       out=  BWT($.t)                            /*invoke the  BWT  function, get result*/
       ori= iBWT(out)                            /*   "    "  iBWT      "      "     "  */
       say '   input ───► '   $.t                /*display    input      string to term.*/
       say '  output ───► '   out                /*   "       output        "    "   "  */
       say 'original ───► '   ori                /*   "    reconstituted    "    "   "  */
       end    /*t*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
BWT:   procedure expose ?.; parse arg y,,$       /*obtain the input;  nullify $ string. */
       ?.1= 'fd'x;          ?.2= "fc"x           /*assign the  STX  and  ETX  strings.  */
          do i=1  for 2                          /* [↓]  check for invalid input string.*/
          _= verify(y, ?.i, 'M');  if _==0  then iterate;        er= '***error***  BWT: '
          say er "invalid input: "    y
          say er 'The input string contains an invalid character at position' _"."; exit _
          end   /*i*/                            /* [↑]  if error,  perform a hard exit.*/
       y= ?.1 || y || ?.2;      L= length(y)     /*get the input & add a fence; gel len.*/
       @.1= y;                  m= L - 1         /*define the first element of the table*/
                    do j=2  for m;        _= j-1 /*now, define the rest of the elements.*/
                    @.j= right(@._,1)left(@._,m) /*construct a table from the  Y  input.*/
                    end   /*j*/                  /* [↑]  each element: left & right part*/
       call cSort L                              /*invoke lexicographical sort for array*/
                    do k=1  for L                /* [↓]  construct the answer from array*/
                    $= $  ||  right(@.k, 1)      /*build the answer from each of  ···   */
                    end   /*k*/                  /* ··· the array's right─most character*/
       return $                                  /*return the constructed answer.       */
/*──────────────────────────────────────────────────────────────────────────────────────*/
iBWT:  procedure expose ?.; parse arg y,,@.      /*obtain the input;  nullify @. string.*/
       L= length(y)                              /*compute the length of the input str. */
                   do   j=1  for L               /* [↓]  step through each input letters*/
                     do k=1  for L               /* [↓]  step through each row of table.*/
                     @.k= substr(y, k, 1) || @.k /*construct a row of the table of chars*/
                     end   /*k*/                 /* [↑]  order of table row is inverted.*/
                   call cSort L                  /*invoke lexicographical sort for array*/
                   end    /*j*/                  /* [↑]  answer is the penultimate entry*/
         do #=1
         if right(@.#, 1)==?.2  then return substr(@.#, 2, L-2)  /*return correct result*/
         end   /*#*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
cSort: procedure expose @.;  parse arg n;  m=n-1 /*N: is the number of @ array elements.*/
           do m=m  for m  by -1  until ok;  ok=1 /*keep sorting the  @ array until done.*/
             do j=1  for m;  k= j+1;   if @.j<<=@.k  then iterate   /*elements in order?*/
             _= @.j;  @.j= @.k;  @.k= _;   ok= 0 /*swap two elements;  flag as not done.*/
             end   /*j*/
           end     /*m*/;       return
