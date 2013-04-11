 ∙
 ∙
 ∙
prod=1
a=7               /*or somesuch.*/
b=3               /*  likewise. */

op='**'           /*or whatever.*/
 ∙
 ∙
 ∙
  select
  when op=='+'         then  r=a+b           /*add.                   */
  when op=='-'         then  r=a-b           /*subtract.              */
  when op=='*'         then do; r=a*b; prod=prod*r; end    /*multiply.*/
  when op=='*'         then  r=a*b           /*multiply.              */
  when op=='/'  & b\=0 then  r=a/b           /*divide.                */
  when op=='%'  & b\=0 then  r=a/b           /*interger divide.       */
  when op=='//' & b\=0 then  r=a/b           /*modulus (remainder).   */
  when op=='||'        then  r=a||b          /*concatenation.         */
  when op=='caw'       then  r=xyz(a,b)      /*call the XYZ subroutine*/
  otherwise                  r='[n/a]'       /*signify not applicable.*/
  end

say 'result for' a op b "=" r
