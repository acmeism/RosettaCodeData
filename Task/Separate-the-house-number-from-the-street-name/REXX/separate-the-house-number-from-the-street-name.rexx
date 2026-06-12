/*REXX program splits  an European mail address  into  an address  and  a house number. */
                                       != '│'    /*a pipe-ish symbol for $ concatenation*/
         $= "Plataanstraat 5"          ! ,
            "Straat 12"                ! ,
            "Straat 12 II"             ! ,
            "Dr. J. Straat   12"       ! ,
            "Dr. J. Straat 12 a"       ! ,
            "Dr. J. Straat 12-14"      ! ,
            "Laan 1940 - 1945 37"      ! ,
            "Plein 1940 2"             ! ,
            "1213-laan 11"             ! ,
            "16 april 1944 Pad 1"      ! ,
            "1e Kruisweg 36"           ! ,
            "Laan 1940-'45 66"         ! ,
            "Laan '40-'45"             ! ,
            "Langeloërduinen 3 46"     ! ,
            "Provincialeweg N205 1"    ! ,
            "Rivium 2e Straat 59."     ! ,
            "Nieuwe gracht 20rd"       ! ,
            "Nieuwe gracht 20rd 2"     ! ,
            "Nieuwe gracht 20zw /2"    ! ,
            "Nieuwe gracht 20zw/3"     ! ,
            "Nieuwe gracht 20 zw/4"    ! ,
            "Bahnhofstr. 4"            ! ,
            "Wertstr. 10"              ! ,
            "Lindenhof 1"              ! ,
            "Nordesch 20"              ! ,
            "Weilstr. 6"               ! ,
            "Harthauer Weg 2"          ! ,
            "Mainaustr. 49"            ! ,
            "August-Horch-Str. 3"      ! ,
            "Marktplatz 31"            ! ,
            "Schmidener Weg 3"         ! ,
            "Karl-Weysser-Str. 6"
$=space($)
w=0
       do j=1  until $=='';  parse var $ addr '│' $
       @.j=space(addr);      w=max(w, length(@.j) )
       end   /*j*/                               /* [↑]  parse  $  string, make @ array.*/
w=w+2                                            /*expand the width for the display.    */
say center('address', w)         center('house number', 12)
say center('',        w, "═")    center(''            , 12, "═")
#=j-1                                            /*define the number of addresses in  $.*/

       do k=1  for  #;           sp=split(@.k)   /*split each  @.  address: addr, house#*/
       HN=subword(@.k, sp+1);    if HN==''  then HN='   (none) '  /*handle a null house#*/
       say left( subword(@.k, 1, sp), w)         HN
       end   /*k*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
split: procedure; parse arg txt;   n=words(txt);   s=n-1;   p=word(txt,s);   e=word(txt,n)
       if p>1939 & p<1946 | s<2    then p=.    ;   if verify("'",e,"M")\==0  then return n
       pl=verify(0123456789, left(p,1), 'M')\==0
       if (verify('/', e, "M")\==0  &  pl)  |  datatype(p, 'W')  | ,
          (datatype(e, 'N')  &  pl & \verify("'", p, "M"))  then s=s-1
       if s==0  then s=n                         /*if no split, then relocate split to ∞*/
       return s                                  /* [↑]  indicate where to split the txt*/
