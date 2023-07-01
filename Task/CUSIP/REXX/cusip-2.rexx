/*REXX program validates that the  last digit (the check digit)  of a  CUSIP  is valid. */
@.=
parse arg @.1 .
if @.1=='' | @.1==","  then do;   @.1= 037833100       /* Apple Incorporated            */
                                  @.2= 17275R102       /* Cisco Systems                 */
                                  @.3= 38259P508       /* Google Incorporated           */
                                  @.4= 594918104       /* Microsoft Corporation         */
                                  @.5= 68389X106       /* Oracle Corporation (incorrect)*/
                                  @.6= 68389X105       /* Oracle Corporation            */
                            end

     do j=1  while @.j\='';   chkDig=CUSIPchk(@.j)     /*calculate check digit from func*/
     OK=word("isn't is", 1 + (chkDig==right(@.j,1) ) ) /*validate  check digit with func*/
     say 'CUSIP '    @.j    right(OK, 6)     "valid."  /*display the CUSIP and validity.*/
     end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
CUSIPchk: procedure; arg x 9;  $=0;         abc= '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ*@#'
                                      /* [↓]  if  Y  isn' found,  then POS returns zero.*/
                                    do k=1  for 8;   y=substr(x,k,1) /*get a character. */
                                    #=pos(y, abc) - 1                /*get its position.*/
                                    if #   == -1  then return 0      /*invalid character*/
                                    if k//2==  0  then #=#+#         /*K even? double it*/
                                    $=$ + #%10 + #//10
                                    end      /*k*/
          return (10-$//10) // 10
