/*REXX program to  create  and  display  an identity matrix.            */
call identity_matrix 4                 /*build and display a 4x4 matrix.*/
call identity_matrix 5                 /*build and display a 5x5 matrix.*/
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────IDENTITY_MATRIX subroutine───────*/
identity_matrix:  procedure;  parse arg n;  $=

    do r=1 for n                       /*build indentity matrix, by row,*/
          do c=1 for n                 /*                    and by cow.*/
          $=$ (r==c)                   /*append zero or one (if on diag)*/
          end    /*c*/
    end          /*r*/

call showMatrix 'identity matrix of size' n,$,n
return
/*─────────────────────────────────────TELL subroutine───&find the order*/
showMatrix: procedure; parse arg hdr,x,order,sep;  if sep=='' then sep='═'
    width=2          /*width of field to be used to display the elements*/
decPlaces=1          /*# decimal places to the right of decimal point.  */
say;  say center(hdr,max(length(hdr)+6,(width+1)*words(x)%order),sep); say
#=0
           do row=1      for order;   aLine=
                do col=1 for order;   #=#+1
                aLine=aLine  right(format(word(x,#),,decPlaces)/1, width)
                end   /*col*/          /*dividing by 1 normalizes the #.*/
           say aLine
           end        /*row*/
return
