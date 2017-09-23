/*REXX program encodes a  URL  text,    blanks ──► +,    preserves  -._*    and   -._~  */
url.=;                              url.1= 'http://foo bar/'
                                    url.2= 'mailto:"Ivan Aim" <ivan.aim@email.com>'
                                    url.3= 'mailto:"Irma User" <irma.user@mail.com>'
                                    url.4= 'http://foo.bar.com/~user-name/_subdir/*~.html'
     do j=1  while url.j\=='';  say
     say '  original: '             url.j
     say '   encoded: '   URLencode(url.j)
     end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
URLencode: procedure; parse arg $,,z;        t1= '-._~'              /*get args, null Z.*/
           skip=0;                           t2= '-._*'
                    do k=1  for length($);   _=substr($, k, 1)       /*get a character. */
                    if skip\==0  then do;    skip=skip-1             /*skip t1 or t2 ?  */
                                             iterate                 /*skip a character.*/
                                      end
                       select
                       when datatype(_, 'A')    then z=z || _        /*is alphanumeric ?*/
                       when _==' '              then z=z'+'          /*is it  a  blank ?*/
                       when substr($, k, 4)==t1 |,                   /*is it  t1 or t2 ?*/
                            substr($, k, 4)==t2   then do;  skip=3   /*skip 3 characters*/
                                                            z=z || substr($, k, 4)
                                                       end
                       otherwise   z=z'%'c2x(_)                      /*special character*/
                       end   /*select*/
                    end      /*k*/
           return z
