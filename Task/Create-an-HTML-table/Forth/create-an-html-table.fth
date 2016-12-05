include random.hsf

\ parser routines
:  totag
               [char] < PARSE pad place              \ parse input up to '<' char
                -1 >in +!                            \ move the interpreter pointer back 1 char
                pad count type  ;

: '"'        [char] " emit ;
: '"..'      '"'  space ;                            \ output a quote char with trailing space

: toquote                                            \ parse input to " then print as quoted text
              '"' [char] " PARSE pad place
              pad count type '"..' ;

: >          [char] > emit space  ;                  \ output the '>' with trailing space

\ Create some HTML extensions to the Forth interpreter
: <table>         ." <table>" cr ;          : </table>   ." </table>"  cr ;
: <table          ." <table " ;
: style="         ." style="  toquote ;
: align="         ." align="  toquote ;
: border="        ." border=" toquote ;
: width="         ." width="  toquote ;
: cellspacing="   ." cellspacing="  toquote ;
: colspacing="    ." colspacing="   toquote ;

: <tr>       ." <tr>" cr ;                  : </tr>      ." </tr>"  cr ;
: <td>       ." <td> "  totag  ;            : </td>      ." </td>"  cr ;
: <td        ." <td " ;
: <thead>    ." <thead>" ;                  : </thead>   ." </thead>" ;
: <th>       ." <th>" ;                     : </th>      ." </th>"  cr ;
: <th        ." <th "  ;
: <tbody     ." <tbody " ;                  : </tbody>   ." </tbody> " ;
: <caption>  cr ." <caption>"  totag  ;     : </caption> ." </caption>"  cr ;

\ Write the source code that generates HTML in our EXTENDED FORTH
cr
<table border=" 1" width=" 30%" >
<caption> This table was created with FORTH HTML tags</caption>
<tr>
<th align=" right" >       </th>
<th align=" right" > ." A" </th>
<th align=" right" > ." B" </th>
<th align=" right" > ." C" </th>
</tr>
<tr>
<th align=" right" >        1 . </th>
<td align=" right" > 1000 RND . </td>
<td align=" right" > 1000 RND . </td>
<td align=" right" > 1000 RND . </td>
</tr>
<tr>
<th align=" right" >        2 . </th>
<td align=" right" > 1000 RND . </td>
<td align=" right" > 1000 RND . </td>
<td align=" right" > 1000 RND . </td>
</tr>
<tr>
<th align=" right" >        3 . </th>
<td align=" right" > 1000 RND . </td>
<td align=" right" > 1000 RND . </td>
<td align=" right" > 1000 RND . </td>
</tr>
</table>
