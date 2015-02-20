/*REXX program shows using   Horner's rule   for  polynomial evaluation.*/
numeric digits 30                      /*use extra numeric precision.   */
parse  arg  x poly                     /*get value of X and coefficients*/
equ=                                   /*start with equation clean slate*/
                                       /*works for any degree equation. */
  do deg=0  until  poly==''            /*get the equation's coefficients*/
  parse  var  poly  c.deg poly         /*get  a  equation   coefficient.*/
  c.deg = c.deg / 1                    /*normalize it (by dividing by 1)*/
  if c.deg>=0  then c.deg = '+'c.deg   /*if ¬ neg, then prefix a + sign.*/
  equ=equ c.deg                        /*concatenate it to the equation.*/
  if deg\==0 & c.deg\=0  then equ= ,   /*if not the first coefficient & */
                           equ'∙x^'deg /* not 0,  append power (^) of X.*/
  equ = equ '  '                       /*insert some blanks, look pretty*/
  end   /*deg*/

say '         x = ' x
say '    degree = ' deg
say '  equation = ' equ
a=c.deg
                       do j=deg  by -1  for deg   /*apply Horner's rule.*/
                       _ = j-1
                       a = a*x + c._
                       end   /*j*/
say
say '    answer = ' a                  /*stick a fork in it, we're done.*/
