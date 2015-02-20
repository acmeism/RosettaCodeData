/*REXX pgm encodes an URL text, blanks──►+, preserves  -._*  and  -._~  */
url.1 = 'http://foo bar/'
url.2 = 'mailto:"Ivan Aim" <ivan.aim@email.com>'
url.3 = 'mailto:"Irma User" <irma.user@mail.com>'
url.4 = 'http://foo.bar.com/~user-name/_subdir/*~.html'
URLs  = 4
             do j=1  for URLs;     say
             say url.j
             say URLencode(url.j)
             end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────URLENCODE subroutine────────────────*/
URLencode: procedure; parse arg yyy;   t1= '-._~' ;               skip=0
                                       t2= '-._*' ;               z=''

          do k=1  for length(yyy);     _=substr(yyy,k,1) /*pickoff 1char*/
          if skip\==0  then do                           /*skip t1 | t2?*/
                            skip=skip-1                  /*skip a char. */
                            iterate
                            end
            select
            when datatype(_,'A')       then z=z || _     /*alphanumeric?*/
            when _==' '                then z=z'+'       /*is a blank ? */
            when substr(yyy,k,4)==t1 |,                  /*t1  or  t2 ? */
                 substr(yyy,k,4)==t2   then do;  skip=3  /*skip 3 chars.*/
                                            z=z || substr(yyy,k,4)
                                            end
            otherwise                       z=z'%'c2x(_) /*special char.*/
            end   /*select*/
          end     /*k*/
return z
