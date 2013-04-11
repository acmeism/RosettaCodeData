/*REXX program  sorts  a stemmed array using the   quicksort   method.  */
call gen@                              /*generate the array elements.   */
call show@ 'before sort'               /*show   before   array elements.*/
call quickSort highItem                /*here come da judge, here come..*/
call show@ ' after sort'               /*show    after   array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────QUICKSORT subroutine────────────────*/
quickSort: procedure expose @.         /*access the caller's local var. */
a.1=1;   b.1=arg(1);   $=1

  do while $\==0;   l=a.$;   t=b.$;   $=$-1
  if t<2 then iterate
  h=l+t-1
  ?=l+t%2
  if @.h<@.l then if @.?<@.h then do; p=@.h; @.h=@.l; end
                             else if @.?>@.l then p=@.l
                                             else do; p=@.?; @.?=@.l; end
             else if @.?<@.l then p=@.l
                             else if @.?>@.h then do; p=@.h; @.h=@.l; end
                                             else do; p=@.?; @.?=@.l; end
  j=l+1
  k=h
        do forever
            do j=j       while j<=k & @.j<=p; end    /*a tinie-tiny loop*/
            do k=k by -1 while j <k & @.k>=p; end    /*another tiny loop*/
        if j>=k then leave
        _=@.j; @.j=@.k; @.k=_
        end   /*forever*/

  k=j-1;  @.l=@.k;  @.k=p
  $=$+1
  if j<=? then do;   a.$=j;  b.$=h-j+1;  $=$+1;  a.$=l;  b.$=k-l;     end
          else do;   a.$=l;  b.$=k-l;    $=$+1;  a.$=j;  b.$=h-j+1;   end
  end   /*while $\==0*/

return
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@: @.=''; maxL=0                    /*assign default value.     */
@.1 =" Rivers that form part of a state's (USA) border "
@.2 ='='
@.3 ="Chattahoochee River:                Alabama, Georgia"
@.4 ="Colorado River:                     Arizona, Nevada, California, Baja California (Mexico)"
@.5 ="St. Francis River:                  Arkansas, Missouri"
@.6 ="Poteau River:                       Arkansas, Oklahoma"
@.7 ="Byram River:                        Connecticut, New York"
@.8 ="Pawcatuck River:                    Connecticut, Rhode Island"
@.9 ="Perdido River:                      Florida, Alabama"
@.10="St. Marys River:                    Florida, Georgia"
@.11="Chattooga River:                    Georgia, South Carolina"
@.12="Tugaloo River:                      Georgia, South Carolina"
@.13="Snake River:                        Idaho, Washington, Oregon"
@.14="Wabash River:                       Illinois, Indiana"
@.15="Ohio River:                         Illinois, Indiana, Ohio, Kentucky, West Virginia"
@.16="Des Moines River:                   Iowa, Missouri"
@.17="Tennessee River:                    Kentucky, Tennessee, Mississippi, Alabama"
@.18="Big Sandy River:                    Kentucky, West Virginia"
@.19="Tug Fork River:                     Kentucky, West Virginia, Virginia"
@.20="Monument Creek:                     Maine, New Brunswick (Canda)"
@.21="St. Croix River:                    Maine, New Brunswick (Canda)"
@.22="Piscataqua River:                   Maine, New Hampshire"
@.23="St. Francis River:                  Maine, Quebec (Canada)"
@.24="St. John River:                     Maine, Quebec (Canada)"
@.25="Pocomoke River:                     Maryland, Virginia"
@.26="Potomac River:                      Maryland, Virginia, city of Washington (District of Columbia), West Virginia"
@.27="Montreal River:                     Michigan (upper peninsula ), Wisconsin"
@.28="Detroit River:                      Michigan, Ontario (Canada)"
@.29="St. Clair River:                    Michigan, Ontario (Canada)"
@.30="St. Marys River:                    Michigan, Ontario (Canada)"
@.31="Brule River:                        Michigan, Wisconsin"
@.32="Menominee River:                    Michigan, Wisconsin"
@.33="Pigeon River:                       Minnesota, Ontario (Canada)"
@.34="Rainy River:                        Minnesota, Ontario (Canada)"
@.35="St. Croix River:                    Minnesota, Wisconsin"
@.36="St. Louis River:                    Minnesota, Wisconsin"
@.37="Mississippi River:                  Minnesota, Wisconsin, Iowa, Illinois, Missouri, Kentucky, Tennesse, Arkansas, Mississippi, Louisiana"
@.38="Pearl River:                        Mississippi, Louisiana"
@.39="Halls Stream:                       New Hampshire, Canada"
@.40="Salmon Falls River:                 New Hampshire, Maine"
@.41="Connecticut River:                  New Hampshire, Vermont"
@.42="Hudson River (lower part only):     New Jersey, New York"
@.43="Arthur Kill:                        New Jersey, New York (tidal strait)"
@.44="Kill Van Kull:                      New Jersey, New York (tidal strait)"
@.45="Rio Grande:                         New Mexico, Texas, Tamaulipas (Mexico), Nuevo Leon (Mexico), Coahuila De Zaragoza (Mexico), Chihuahua (Mexico)"
@.46="Niagara River:                      New York, Ontario (Canada)"
@.47="St. Lawrence River:                 New York, Ontario (Canada)"
@.48="Delaware River:                     New York, Pennsylvania, New Jersey, Delaware"
@.49="Catawba River:                      North Carolina, South Carolina"
@.50="Red River of the North:             North Dakota, Minnesota"
@.51="Great Miami River (mouth only):     Ohio, Indiana"
@.52="Arkansas River:                     Oklahoma, Arkansas"
@.53="Palmer River:                       Rhode Island, Massachusetts"
@.54="Runnins River:                      Rhode Island, Massachusetts"
@.55="Savannah River:                     South Carolina, Georgia"
@.56="Big Sioux River:                    South Dakota, Iowa"
@.57="Bois de Sioux River:                South Dakota, Minnesota, North Dakota"
@.58="Missouri River:                     South Dakota, Nebraska, Iowa, Missouri, Kansas"
@.59="Sabine River:                       Texas, Louisiana"
@.60="Red River (Mississippi watershed):  Texas, Oklahoma, Arkansas"
@.61="Poultney River:                     Vermont, New York"
@.62="Blackwater River:                   Virginia, North Carolina"
@.63="Columbia River:                     Washington, Oregon"

  do highItem=1 while @.highItem\==''  /*find how many entries, and also*/
  maxL=max(maxL,length(@.highItem))    /*  find the maximum width entry.*/
  end

highItem=highItem-1                    /*adjust highItem slightly.      */
@.1=centre(@.1,maxL,'-')               /*adjust the header information. */
@.2=copies(@.2,maxL)                   /*adjust the header separator.   */
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@: widthH=length(highItem)         /*maximum width of any line.     */

                     do j=1 for highItem         /*show each array item.*/
                     say  'element'  right(j,widthH)  arg(1)':'  @.j
                     end

say copies('█',maxL+widthH+22)              /*show a separator line.    */
return
