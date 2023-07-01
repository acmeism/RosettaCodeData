/*REXX program  sorts  a  stemmed array  using the  shell sort  (shellsort) algorithm.  */
call gen                                         /*generate the array elements.         */
call show           'before sort'                /*display the  before  array elements. */
                 say copies('▒', 75)             /*displat a separator line  (a fence). */
call shellSort       #                           /*invoke the  shell  sort.             */
call show           ' after sort'                /*display the   after  array elements. */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen: @.=                                         /*assign a default value to stem array.*/
     @.1= '3 character abbreviations for states of the USA'         /*predates ZIP code.*/
     @.2= '==============================================='
     @.3= 'RHO  Rhode Island and Providence Plantations'     ;  @.36= 'NMX  New Mexico'
     @.4= 'CAL  California'    ;   @.20= "NEV  Nevada"       ;  @.37= 'IND  Indiana'
     @.5= 'KAN  Kansas'        ;   @.21= "TEX  Texas"        ;  @.38= 'MOE  Missouri'
     @.6= 'MAS  Massachusetts' ;   @.22= "VGI  Virginia"     ;  @.39= 'COL  Colorado'
     @.7= 'WAS  Washington'    ;   @.23= "OHI  Ohio"         ;  @.40= 'CON  Connecticut'
     @.8= 'HAW  Hawaii'        ;   @.24= "NHM  New Hampshire";  @.41= 'MON  Montana'
     @.9= 'NCR  North Carolina';   @.25= "MAE  Maine"        ;  @.42= 'LOU  Louisiana'
    @.10= 'SCR  South Carolina';   @.26= "MIC  Michigan"     ;  @.43= 'IOW  Iowa'
    @.11= 'IDA  Idaho'         ;   @.27= "MIN  Minnesota"    ;  @.44= 'ORE  Oregon'
    @.12= 'NDK  North Dakota'  ;   @.28= "MIS  Mississippi"  ;  @.45= 'ARK  Arkansas'
    @.13= 'SDK  South Dakota'  ;   @.29= "WIS  Wisconsin"    ;  @.46= 'ARZ  Arizona'
    @.14= 'NEB  Nebraska'      ;   @.30= "OKA  Oklahoma"     ;  @.47= 'UTH  Utah'
    @.15= 'DEL  Delaware'      ;   @.31= "ALA  Alabama"      ;  @.48= 'KTY  Kentucky'
    @.16= 'PEN  Pennsylvania'  ;   @.32= "FLA  Florida"      ;  @.49= 'WVG  West Virginia'
    @.17= 'TEN  Tennessee'     ;   @.33= "MLD  Maryland"     ;  @.50= 'NWJ  New Jersey'
    @.18= 'GEO  Georgia'       ;   @.34= "ALK  Alaska"       ;  @.51= 'NYK  New York'
    @.19= 'VER  Vermont'       ;   @.35= "ILL  Illinois"     ;  @.52= 'WYO  Wyoming'
         do #=1  until @.#=='';  end;  #= #-1    /*determine number of entries in array.*/
    return
/*──────────────────────────────────────────────────────────────────────────────────────*/
shellSort: procedure expose @.;   parse arg n    /*obtain the  n  from the argument list*/
           i= n % 2                              /*%   is integer division in REXX.     */
                   do  while i\==0
                          do j=i+1  to n;    k= j;      p= k - i      /*P: previous item*/
                          _= @.j
                                 do  while k>=i+1 & @.p>_;    @.k= @.p;   k= k-i;   p= k-i
                                 end   /*while*/
                          @.k= _
                          end          /*j*/
                   if i==2  then i= 1
                            else i= i * 5 % 11
                   end                 /*while*/
           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:   do j=1  for #;  say 'element'  right(j, length(#) ) arg(1)": "  @.j;  end;  return
