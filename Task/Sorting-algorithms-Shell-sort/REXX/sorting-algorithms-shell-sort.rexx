/*REXX program sorts an (stemmed) array using the  shellsort  method.   */
call gen@                              /*generate the array elements.   */
call show@ 'before sort'               /*show the before array elements.*/
call shellSort highItem                /*invoke the shell sort.         */
call show@ ' after sort'               /*show the  after array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@:  @.=                             /*assign default value to stem.  */
 @.1='3 character abbreviations for states of the USA'   /*predates ZIP.*/
 @.2='==============================================='
 @.3='RHO  Rhode Island and Providence Plantations'  ; @.36='NMX  New Mexico'
 @.4='CAL  California'    ; @.20='NEV  Nevada'       ; @.37='IND  Indiana'
 @.5='KAN  Kansas'        ; @.21='TEX  Texas'        ; @.38='MOE  Missouri'
 @.6='MAS  Massachusetts' ; @.22='VGI  Virginia'     ; @.39='COL  Colorado'
 @.7='WAS  Washington'    ; @.23='OHI  Ohio'         ; @.40='CON  Connecticut'
 @.8='HAW  Hawaii'        ; @.24='NHM  New Hampshire'; @.41='MON  Montana'
 @.9='NCR  North Carolina'; @.25='MAE  Maine'        ; @.42='LOU  Louisiana'
@.10='SCR  South Carolina'; @.26='MIC  Michigan'     ; @.43='IOW  Iowa'
@.11='IDA  Idaho'         ; @.27='MIN  Minnesota'    ; @.44='ORE  Oregon'
@.12='NDK  North Dakota'  ; @.28='MIS  Mississippi'  ; @.45='ARK  Arkansas'
@.13='SDK  South Dakota'  ; @.29='WIS  Wisconsin'    ; @.46='ARZ  Arizona'
@.14='NEB  Nebraska'      ; @.30='OKA  Oklahoma'     ; @.47='UTH  Utah'
@.15='DEL  Delaware'      ; @.31='ALA  Alabama'      ; @.48='KTY  Kentucky'
@.16='PEN  Pennsylvania'  ; @.32='FLA  Florida'      ; @.49='WVG  West Virginia'
@.17='TEN  Tennessee'     ; @.33='MLD  Maryland'     ; @.50='NWJ  New Jersey'
@.18='GEO  Georgia'       ; @.34='ALK  Alaska'       ; @.51='NYK  New York'
@.19='VER  Vermont'       ; @.35='ILL  Illinois'     ; @.52='WYO  Wyoming'

  do highItem=1 while @.highItem\==''  /*find how many entries in array.*/
  end

highItem=highItem-1                    /*adjust the  highItem  slightly.*/
return
/*──────────────────────────────────SHELLSORT subroutine───────---──────*/
shellSort:  procedure expose @.;   parse arg highItem
i=highItem%2
              do while i\==0
                      do j=i+1 to  highItem;    k=j;    kmi=k-i
                      _=@.j
                               do  while k>=i+1  &  @.kmi>_;    @.k=@.kmi
                               k=k-i;    kmi=k-i
                               end    /*while k>=i+1 & ...*/
                      @.k=_
                      end   /*j*/

              if i==2  then i=1
                       else i=i*5%11
              end   /*while i\==0*/
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@:  widthH=length(highItem)        /*maximum width of any line.     */
                       do j=1  for highItem
                       say   'element'   right(j,widthH) arg(1)': '    @.j
                       end   /*j*/
say copies('─',79)                     /*show a separator line (a fence)*/
return
